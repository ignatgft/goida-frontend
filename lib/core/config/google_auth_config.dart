import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthConfig {
  const GoogleAuthConfig._();

  // Google Client ID: 1021431144189-7tqhb0pare644pauck40j728vdos7dup.apps.googleusercontent.com
  static const String _webClientId = "1021431144189-7tqhb0pare644pauck40j728vdos7dup.apps.googleusercontent.com";
  static const String _serverClientId = "1021431144189-7tqhb0pare644pauck40j728vdos7dup.apps.googleusercontent.com";

  static GoogleSignIn createGoogleSignIn() {
    return GoogleSignIn(
      scopes: const ['email', 'profile'],
      clientId: _webClientId.isEmpty ? null : _webClientId,
      serverClientId: _serverClientId.isEmpty ? null : _serverClientId,
    );
  }
}
