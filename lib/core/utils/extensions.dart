import 'package:intl/intl.dart';

extension IntPaise on int {
  String toRupeeString() {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 2,
    );
    return formatter.format(this / 100);
  }

  String toDecimalString() {
    final formatter = NumberFormat('#,##0.00', 'en_IN');
    return formatter.format(this / 100);
  }
}

extension DoublePercent on double {
  String toPercentString() {
    final sign = this >= 0 ? '+' : '';
    return '$sign${toStringAsFixed(2)}%';
  }
}
