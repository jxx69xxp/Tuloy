import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// ₱1,234.50. Uses the 'en' number symbols for every app language (intl has none for Bisaya).
String money(double amount, String currency) => NumberFormat.currency(
  locale: 'en',
  symbol: currency == 'PHP' ? '₱' : '$currency ',
  decimalDigits: 2,
).format(amount);

/// Localized medium date via Flutter's own localizations (Bisaya falls back to Filipino).
String date(BuildContext context, DateTime d) => MaterialLocalizations.of(context).formatMediumDate(d);

String dateRange(BuildContext context, DateTime from, DateTime to) => '${date(context, from)} – ${date(context, to)}';
