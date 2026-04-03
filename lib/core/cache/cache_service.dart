import 'package:hive_flutter/hive_flutter.dart';

/// Сервис локального кэширования с использованием Hive
/// Обеспечивает offline доступ к данным и уменьшает запросы к API
class CacheService {
  static final CacheService _instance = CacheService._internal();
  factory CacheService() => _instance;
  CacheService._internal();

  // Названия box'ов
  static const String _transactionsBox = 'transactions_cache';
  static const String _ratesBox = 'rates_cache';
  static const String _dashboardBox = 'dashboard_cache';
  static const String _settingsBox = 'settings_cache';

  // TTL для разных типов данных
  static const Duration transactionsTTL = Duration(minutes: 5);
  static const Duration ratesTTL = Duration(minutes: 10);
  static const Duration dashboardTTL = Duration(minutes: 2);
  static const Duration settingsTTL = Duration(hours: 1);

  bool _initialized = false;

  /// Инициализация Hive
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      await Hive.initFlutter();
      
      // Открываем box'ы
      await Future.wait([
        Hive.openBox(_transactionsBox),
        Hive.openBox(_ratesBox),
        Hive.openBox(_dashboardBox),
        Hive.openBox(_settingsBox),
      ]);

      _initialized = true;
      debugPrint('CacheService initialized');
    } catch (e) {
      debugPrint('CacheService initialization error: $e');
      rethrow;
    }
  }

  /// Получить кэшированные транзакции
  Future<dynamic> getCachedTransactions({String? category, String? period}) {
    return _getWithTTL(
      _transactionsBox,
      'transactions_${category ?? 'all'}_${period ?? 'month'}',
      transactionsTTL,
    );
  }

  /// Сохранить транзакции в кэш
  Future<void> cacheTransactions({
    required String category,
    required String period,
    required dynamic data,
  }) {
    return _putWithTimestamp(
      _transactionsBox,
      'transactions_${category}_$period',
      data,
    );
  }

  /// Получить кэшированные курсы
  Future<dynamic> getCachedRates(String type) {
    return _getWithTTL(_ratesBox, 'rates_$type', ratesTTL);
  }

  /// Сохранить курсы в кэш
  Future<void> cacheRates({required String type, required dynamic data}) {
    return _putWithTimestamp(_ratesBox, 'rates_$type', data);
  }

  /// Получить кэшированный дашборд
  Future<dynamic> getCachedDashboard({String? period}) {
    return _getWithTTL(
      _dashboardBox,
      'dashboard_${period ?? 'month'}',
      dashboardTTL,
    );
  }

  /// Сохранить дашборд в кэш
  Future<void> cacheDashboard({required String period, required dynamic data}) {
    return _putWithTimestamp(_dashboardBox, 'dashboard_$period', data);
  }

  /// Получить настройки
  Future<dynamic> getCachedSettings(String key) {
    return _getWithTTL(_settingsBox, key, settingsTTL);
  }

  /// Сохранить настройки
  Future<void> cacheSetting({required String key, required dynamic value}) {
    return _putWithTimestamp(_settingsBox, key, value);
  }

  /// Получить данные с проверкой TTL
  Future<dynamic> _getWithTTL(String boxName, String key, Duration ttl) {
    final box = Hive.box(boxName);
    final cachedAt = box.get('${key}_timestamp');
    
    if (cachedAt != null) {
      final now = DateTime.now();
      final cachedTime = DateTime.fromMillisecondsSinceEpoch(cachedAt);
      final age = now.difference(cachedTime);
      
      if (age < ttl) {
        // Данные актуальны
        return box.get(key);
      } else {
        // Данные устарели
        debugPrint('Cache expired for $key (age: ${age.inSeconds}s, TTL: ${ttl.inSeconds}s)');
        box.delete(key);
        box.delete('${key}_timestamp');
      }
    }
    
    return null;
  }

  /// Сохранить данные с timestamp
  Future<void> _putWithTimestamp(String boxName, String key, dynamic value) {
    final box = Hive.box(boxName);
    return box.putAll({
      key: value,
      '${key}_timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// Очистить конкретный кэш
  Future<void> clearCache(String boxName) {
    final box = Hive.box(boxName);
    return box.clear();
  }

  /// Очистить все кэши
  Future<void> clearAllCaches() async {
    await Future.wait([
      clearCache(_transactionsBox),
      clearCache(_ratesBox),
      clearCache(_dashboardBox),
      clearCache(_settingsBox),
    ]);
    debugPrint('All caches cleared');
  }

  /// Закрыть все box'ы
  Future<void> close() async {
    await Hive.close();
    _initialized = false;
  }
}
