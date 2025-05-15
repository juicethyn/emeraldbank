import 'package:intl/intl.dart';

String formatCurrency(double value) {
  final formatter = NumberFormat.currency(
    symbol: '₱ ',
    decimalDigits: 2,
    locale: 'en_PH',
  );
  return formatter.format(value);
}

double toDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0.0;
}

String hideAccountNumber(String number) {
  final digitsOnly = number.replaceAll(RegExp(r'[^\d]'), '');

  if (digitsOnly.length <= 4) {
    return digitsOnly;
  }

  final visiblePart = digitsOnly.substring(digitsOnly.length - 4);
  final hiddenGroups = (digitsOnly.length - 4) ~/ 4;
  final remainingHidden = (digitsOnly.length - 4) % 4;

  final buffer = StringBuffer();
  for (int i = 0; i < hiddenGroups; i++) {
    buffer.write('**** ');
  }

  if (remainingHidden > 0) {
    buffer.write('*' * remainingHidden + ' ');
  }

  buffer.write(visiblePart);
  return buffer.toString();
}

String formatAccountNumber(String number) {
  final digitsOnly = number.replaceAll(RegExp(r'[^\d]'), '');

  final buffer = StringBuffer();
  for (int i = 0; i < digitsOnly.length; i++) {
    if (i > 0 && i % 4 == 0) {
      buffer.write(' ');
    }
    buffer.write(digitsOnly[i]);
  }
  return buffer.toString();
}

String maskName(String name) {
  final parts = name.split(' ');
  String masked = '';

  for (var part in parts) {
    if (part.length <= 1) {
      masked += '$part ';
    } else {
      masked += '${part[0]}*** ';
    }
  }
  return masked.trim();
}

String formatDateMMDDYYYY(DateTime date) {
  return DateFormat('MM/dd/yyyy').format(date);
}

/// Converts decimal interest rate to percentage format
/// Example: 0.015 → 1.5
double formatInterestRateValue(dynamic rate) {
  if (rate == null) return 0.0;

  double decimalRate;
  if (rate is double) {
    decimalRate = rate;
  } else if (rate is int) {
    decimalRate = rate.toDouble();
  } else if (rate is String) {
    decimalRate = double.tryParse(rate) ?? 0.0;
  } else {
    decimalRate = 0.0;
  }

  return decimalRate * 100;
}

/// Formats interest rate as string with % symbol
/// Example: 0.015 → "1.5%"
String formatInterestRateDisplay(dynamic rate, {int decimalPlaces = 2}) {
  final percentage = formatInterestRateValue(rate);
  return '${percentage.toStringAsFixed(decimalPlaces)}%';
}

String formatDateToWords(String? dateString) {
  if (dateString == null || dateString.isEmpty) {
    return 'No date available';
  }

  try {
    // Parse MM/DD/YYYY format
    final parts = dateString.split('/');
    if (parts.length != 3) {
      return dateString; // Return original if format doesn't match
    }

    final month = int.tryParse(parts[0]);
    final day = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (month == null || day == null || year == null) {
      return dateString; // Return original if parsing fails
    }

    final date = DateTime(year, month, day);

    // Format to Month Day, Year format
    return DateFormat('MMMM d, yyyy').format(date);
  } catch (e) {
    print('Error formatting date: $e');
    return dateString; // Return original on error
  }
}
