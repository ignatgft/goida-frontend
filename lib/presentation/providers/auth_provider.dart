import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/api/api_client.dart';
import '../../core/api/endpoints.dart';
import '../../core/config/google_auth_config.dart';
import '../../data/models/user.dart';

class AuthProvider extends ChangeNotifier {
  static const String _profileKey = 'auth.profile';
  static const String _sessionTokenKey = 'auth.session_token';
  static const String _themeModeKey = 'settings.theme_mode';
  static const String _localeKey = 'settings.locale';

  final ApiClient api;
  final GoogleSignIn _googleSignIn = GoogleAuthConfig.createGoogleSignIn();
  final ImagePicker _picker = ImagePicker();

  SharedPreferences? _prefs;
  GoogleSignInAccount? _user;
  AppUser? _profile;
  bool _isDemoMode = false;
  bool _isLoading = false;
  bool _isUploadingAvatar = false;
  bool _isInitialized = false;

  Uint8List? _avatarBytes;
  ThemeMode _themeMode = ThemeMode.system;
  Locale? _locale;

  AuthProvider(this.api);

  GoogleSignInAccount? get user => _user;
  AppUser? get profile => _profile;
  bool get isLoading => _isLoading;
  bool get isUploadingAvatar => _isUploadingAvatar;
  bool get isDemoMode => _isDemoMode;
  bool get isInitialized => _isInitialized;
  bool get isAuthenticated => _user != null || _profile != null || _isDemoMode;
  String? get sessionKey => _isDemoMode ? 'demo' : (_profile?.id ?? _user?.id);
  String? get avatarUrl => _profile?.avatarUrl ?? _user?.photoUrl;

  ImageProvider<Object>? get avatarImageProvider {
    if (_avatarBytes != null) {
      return MemoryImage(_avatarBytes!);
    }
    final url = avatarUrl;
    if (url != null && url.isNotEmpty) {
      return NetworkImage(url);
    }
    return null;
  }

  ThemeMode get themeMode => _themeMode;
  Locale? get locale => _locale;

  String get displayName => _isDemoMode
      ? "Demo User"
      : (_profile?.displayName ?? _user?.displayName ?? "User");

  String get email =>
      _isDemoMode ? "demo@goida.ai" : (_profile?.email ?? _user?.email ?? "");

  Future<void> initialize() async {
    if (_isInitialized) return;

    _prefs = await SharedPreferences.getInstance();
    _restoreLocalSettings();
    _restorePersistedSession();

    try {
      final googleUser = await _googleSignIn.signInSilently(suppressErrors: true);
      if (googleUser != null) {
        await _applyGoogleUser(googleUser, syncWithBackend: true);
      } else if (_profile != null || api.sessionToken != null) {
        await refreshProfile();
      }
    } catch (e) {
      debugPrint("Error restoring session: $e");
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        await _applyGoogleUser(googleUser, syncWithBackend: true);
      }
    } catch (e) {
      debugPrint("Error Google Sign In: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInAsDev() async {
    _isLoading = true;
    notifyListeners();
    try {
      // Endpoints.baseUrl уже содержит полный путь, например http://10.0.2.2:8080/api
      // Нужно удалить /api и добавить правильный путь
      final baseUrl = Endpoints.baseUrl.endsWith('/api')
          ? Endpoints.baseUrl.substring(0, Endpoints.baseUrl.length - 4)
          : Endpoints.baseUrl;
      
      final response = await api.dio.post(
        '$baseUrl/api/auth/dev',
        data: {
          'email': 'test@goida.ai',
          'fullName': 'Test User',
        },
      );

      final data = response.data as Map<String, dynamic>? ?? const {};
      final sessionToken = _extractSessionToken(data);

      if (sessionToken != null) {
        api.setSessionToken(sessionToken);
        await _prefs?.setString(_sessionTokenKey, sessionToken);
        await refreshProfile();
      }
    } catch (e) {
      debugPrint("Error dev sign in: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshProfile() async {
    if (_isDemoMode) return;
    try {
      final response = await api.get(Endpoints.profile);
      final raw = response.data;
      
      final Map<String, dynamic> data;
      if (raw is Map<String, dynamic>) {
        data = (raw['user'] as Map<String, dynamic>?) ??
               (raw['profile'] as Map<String, dynamic>?) ??
               (raw['data'] as Map<String, dynamic>?) ??
               raw;
      } else {
        data = {};
      }

      if (data.isNotEmpty) {
        _profile = AppUser.fromJson(data);
        _avatarBytes = null;
        await _persistProfile();
        notifyListeners();
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        debugPrint("Session expired or invalid. Clearing session...");
        await signOut();
      }
      debugPrint("Error loading profile: $e");
    }
  }

  Future<bool> pickAndUploadAvatar() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1200,
    );

    if (image == null) return false;

    _avatarBytes = await image.readAsBytes();
    _isUploadingAvatar = true;
    notifyListeners();

    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          _avatarBytes!,
          filename: image.name,
          contentType: DioMediaType('image', 'jpeg'),
        ),
      });

      final response = await api.dio.post(
        Endpoints.profileAvatar,
        data: formData,
      );
      final data = response.data as Map<String, dynamic>? ?? const {};
      final avatarUrl = data['avatarUrl'] ?? data['photoUrl'] ?? data['url'];

      if (_profile != null) {
        _profile = _profile!.copyWith(avatarUrl: avatarUrl);
        await _persistProfile();
      } else if (_user != null) {
        _profile = AppUser(
          id: _user!.id,
          displayName: _user!.displayName ?? "User",
          email: _user!.email,
          avatarUrl: avatarUrl ?? _user!.photoUrl,
        );
        await _persistProfile();
      }

      if (avatarUrl != null) _avatarBytes = null;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Error uploading avatar: $e");
      return false;
    } finally {
      _isUploadingAvatar = false;
      notifyListeners();
    }
  }

  Future<void> _syncGoogleUserWithBackend(GoogleSignInAccount googleUser) async {
    try {
      final auth = await googleUser.authentication;
      debugPrint('Sending Google auth to backend: ${Endpoints.baseUrl}${Endpoints.authGoogle}');
      debugPrint('idToken present: ${auth.idToken != null}');
      debugPrint('accessToken present: ${auth.accessToken != null}');
      
      final response = await api.post(Endpoints.authGoogle, {
        'idToken': auth.idToken,
        'accessToken': auth.accessToken,
        'googleId': googleUser.id,
        'email': googleUser.email,
        'displayName': googleUser.displayName,
        'photoUrl': googleUser.photoUrl,
      });

      debugPrint('Backend response status: ${response.statusCode}');
      debugPrint('Backend response data: ${response.data}');

      if (response.statusCode == 404) {
        debugPrint('ERROR: /auth/google endpoint not found on server!');
        debugPrint('Full URL: ${Endpoints.baseUrl}${Endpoints.authGoogle}');
        // Fallback: create local profile without backend sync
        _profile = AppUser(
          id: googleUser.id,
          displayName: googleUser.displayName ?? "User",
          email: googleUser.email,
          avatarUrl: googleUser.photoUrl,
        );
        await _persistProfile();
        return;
      }

      if (response.statusCode != 200 && response.statusCode != 201) {
        debugPrint('Backend returned error status: ${response.statusCode}');
        // Fallback: create local profile without backend sync
        _profile = AppUser(
          id: googleUser.id,
          displayName: googleUser.displayName ?? "User",
          email: googleUser.email,
          avatarUrl: googleUser.photoUrl,
        );
        await _persistProfile();
        return;
      }

      final data = response.data;
      debugPrint('Response data type: ${data.runtimeType}');
      debugPrint('Response data: $data');
      
      final Map<String, dynamic> dataMap;
      if (data is Map<String, dynamic>) {
        dataMap = data;
      } else if (data is String) {
        dataMap = jsonDecode(data) as Map<String, dynamic>? ?? {};
      } else {
        dataMap = {};
      }
      
      final userJson = dataMap['user'] ?? dataMap['profile'] ?? dataMap['data'] ?? dataMap;
      final sessionToken = _extractSessionToken(dataMap);

      if (sessionToken != null) {
        api.setSessionToken(sessionToken);
        await _prefs?.setString(_sessionTokenKey, sessionToken);
        debugPrint('Session token saved');
      }

      if (userJson is Map<String, dynamic>) {
        _profile = AppUser.fromJson(userJson);
        await _persistProfile();
        debugPrint('Profile synced with backend');
      }
    } catch (e) {
      debugPrint("Error syncing with backend: $e");
      // Fallback: create local profile without backend sync
      _profile = AppUser(
        id: googleUser.id,
        displayName: googleUser.displayName ?? "User",
        email: googleUser.email,
        avatarUrl: googleUser.photoUrl,
      );
      await _persistProfile();
    }
  }

  String? _extractSessionToken(Map<String, dynamic> data) {
    return data['sessionToken'] as String? ??
           data['session_token'] as String? ??
           data['token'] as String? ??
           data['authToken'] as String? ??
           data['auth_token'] as String? ??
           data['accessToken'] as String? ??
           data['access_token'] as String? ??
           (data['session'] as Map?)?['token'] as String?;
  }

  void loginAsDemo() {
    _clearPersistedSession();
    _isDemoMode = true;
    _user = null;
    _profile = const AppUser(id: 'demo', displayName: 'Demo User', email: 'demo@goida.ai');
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    _prefs?.setString(_themeModeKey, mode.name);
    notifyListeners();
  }

  void setLocale(Locale? locale) {
    _locale = locale;
    final languageCode = locale?.languageCode;
    if (languageCode == null) {
      _prefs?.remove(_localeKey);
    } else {
      _prefs?.setString(_localeKey, languageCode);
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    _clearPersistedSession();
    _user = null;
    _profile = null;
    _isDemoMode = false;
    _avatarBytes = null;
    notifyListeners();
  }

  Future<void> _applyGoogleUser(GoogleSignInAccount googleUser, {required bool syncWithBackend}) async {
    _user = googleUser;
    _isDemoMode = false;
    if (syncWithBackend) {
      await _syncGoogleUserWithBackend(googleUser);
      await refreshProfile();
    } else {
      _profile = AppUser(id: googleUser.id, displayName: googleUser.displayName ?? "User", email: googleUser.email, avatarUrl: googleUser.photoUrl);
      await _persistProfile();
    }
  }

  void _restorePersistedSession() {
    final sessionToken = _prefs?.getString(_sessionTokenKey);
    if (sessionToken != null) {
      api.setSessionToken(sessionToken);
    }
    final profileJson = _prefs?.getString(_profileKey);
    if (profileJson != null) {
      try {
        _profile = AppUser.fromJson(jsonDecode(profileJson));
      } catch (_) {}
    }
  }

  Future<void> _persistProfile() async {
    if (_profile == null) {
      await _prefs?.remove(_profileKey);
    } else {
      await _prefs?.setString(_profileKey, jsonEncode(_profile!.toJson()));
    }
  }

  void _clearPersistedSession() {
    api.setSessionToken(null);
    _prefs?.remove(_profileKey);
    _prefs?.remove(_sessionTokenKey);
  }

  void _restoreLocalSettings() {
    final savedTheme = _prefs?.getString(_themeModeKey);
    if (savedTheme != null) {
      _themeMode = ThemeMode.values.firstWhere((m) => m.name == savedTheme, orElse: () => ThemeMode.system);
    }
    final savedLocale = _prefs?.getString(_localeKey);
    if (savedLocale != null) _locale = Locale(savedLocale);
  }
}
