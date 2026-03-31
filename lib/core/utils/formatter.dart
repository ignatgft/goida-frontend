import 'package:intl/intl.dart';
import '../../data/models/balance.dart';

class Formatter {
  static String formatCurrency(double amount, SupportedCurrency currency) {
    final format = NumberFormat.currency(
      locale: 'en_US',
      symbol: _symbol(currency),
      decimalDigits: currency.isCrypto ? 4 : 2,
    );
    return format.format(amount);
  }

  static String formatCompactRate(
    SupportedCurrency baseCurrency,
    SupportedCurrency quoteCurrency,
    double rate,
  ) {
    return '1 ${baseCurrency.code} = ${rate.toStringAsFixed(2)} ${quoteCurrency.code}';
  }

  static String formatPercent(double value) {
    return '${(value * 100).round()}%';
  }

  static String _symbol(SupportedCurrency currency) {
    return '${currency.symbol} ';
  }
}
