import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class Endpoints {
  // Можно переопределить через --dart-define=API_BASE_URL=http://YOUR_IP:8080/api
  static const String _configuredBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
  );

  // Сервер развёрнут на IP 57.151.105.173:3000
  static const String _serverIp = "http://57.151.105.173:3000/api";

  static String get baseUrl {
    // Если задано явно через dart-define
    if (_configuredBaseUrl.isNotEmpty) {
      return _configuredBaseUrl;
    }

    // Все платформы используют сервер 57.151.105.173:3000
    return _serverIp;
  }

  static const String dashboardOverview = "/dashboard/overview";
  static const String assets = "/assets";
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
  static const String processReceipt = "/receipt/process";
  static const String send = "/send";
  static const String topup = "/topup";
}
