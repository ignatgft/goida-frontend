class Endpoints {
  // Можно переопределить через --dart-define=API_BASE_URL=http://YOUR_IP:8080/api
  static const String _configuredBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
  );

  // Сервер развёрнут на IP 57.151.105.173:8080
  static const String _serverIp = "http://57.151.105.173:8080/api";

  static String get baseUrl {
    // Если задано явно через dart-define
    if (_configuredBaseUrl.isNotEmpty) {
      return _configuredBaseUrl;
    }

    // Все платформы используют сервер 57.151.105.173:8080
    return _serverIp;
  }

  static const String dashboardOverview = "/dashboard/overview";
  static const String assets = "/assets";
  static const String assetBalanceSummary = "/assets/balance-summary";
  static const String assetPools = "/asset-pools";
  static const String fiatRates = "/rates/fiat";
  static const String cryptoRates = "/rates/crypto";
  static const String statisticsOverview = "/stats/overview";
  static const String fiatCurrencies = "/currencies/fiat";
  static const String cryptoCurrencies = "/currencies/crypto";
  static const String transactions = "/transactions";
  static const String transactionCategories = "/transactions/categories";
  static const String authGoogle = "/auth/google";
  static const String profile = "/profile";
  static const String profileAvatar = "/profile/avatar";
  static const String chat = "/chat";
  static const String chatConversations = "/chat/conversations";
  static const String aiChatHistory = "/ai-chat";
  static const String processReceipt = "/receipt/process";
  static const String send = "/send";
  static const String topup = "/topup";
  static const String walletConnect = "/wallet-connect";
  
  // Настройки
  static const String settingsProfile = "/settings/profile";
  static const String settingsAvatar = "/settings/avatar";
  static const String settingsPreferences = "/settings/preferences";
  static const String settingsAll = "/settings/all";
  static const String settingsFull = "/settings/full";

  // Аватарки
  static const String avatars = "/avatars";
  static const String activeAvatar = "/avatars/active";

  // Сообщения (мессенджер)
  static const String messages = "/messages";
  static const String conversations = "/messages/conversations";
  static const String unreadMessages = "/messages/unread";

  // Уведомления
  static const String notifications = "/notifications";

  // Напоминания
  static const String reminders = "/reminders";

  // Документы
  static const String documents = "/documents";
}
