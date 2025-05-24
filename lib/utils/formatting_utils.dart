import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

String formatTransactionDateRecent(Timestamp? timestamp) {
  if (timestamp == null) return 'Unknown date';

  final now = DateTime.now();
  final transactionDate = timestamp.toDate();
  final difference = now.difference(transactionDate);

  if (difference.inDays == 0) {
    // Today
    return 'Today, at ${DateFormat('h:mma').format(transactionDate).toLowerCase()}';
  } else if (difference.inDays == 1) {
    // Yesterday
    return 'Yesterday, at ${DateFormat('h:mma').format(transactionDate).toLowerCase()}';
  } else if (difference.inDays < 7) {
    // Within last week
    return '${DateFormat('EEEE').format(transactionDate)}, at ${DateFormat('h:mma').format(transactionDate).toLowerCase()}';
  } else {
    // Older
    return '${DateFormat('MM/dd/yyyy').format(transactionDate)}, at ${DateFormat('h:mma').format(transactionDate).toLowerCase()}';
  }
}

String formatTransactionDateAtHour(Timestamp timestamp) {
  final date = timestamp.toDate();
  return DateFormat('MM/dd/yyyy, \'at\' h:mma').format(date);
}

IconData getTransactionIcon(String? transactionType) {
  // Handle null case first
  if (transactionType == null) return Icons.account_balance_wallet;

  // Convert to lowercase for case-insensitive comparison
  final type = transactionType.toLowerCase().trim();

  switch (type) {
    case 'fund transfer':
      return Icons.swap_horiz;
    case 'bill payment':
      return Icons.receipt_long;
    case 'withdrawal':
      return Icons.money_off;
    case 'deposit':
      return Icons.savings;
    case 'payment':
      return Icons.payment;
    // Add more flexible matching with contains() for partial matches
    default:
      // Try partial matching if exact match fails
      if (type.contains('transfer')) return Icons.swap_horiz;
      if (type.contains('bill') || type.contains('payment')) {
        return Icons.receipt_long;
      }
      if (type.contains('withdraw')) return Icons.money_off;
      if (type.contains('deposit')) return Icons.savings;

      // Ultimate fallback
      return Icons.account_balance_wallet;
  }
}

String getTransactionPartnerName(
  Map<String, dynamic> transaction,
  bool isOutgoing,
) {
  // In a real app, you would fetch the actual name of the transaction partner
  // This is a simplified implementation

  if (isOutgoing) {
    // For outgoing, use destination
    if (transaction['transactionType'] == 'Fund Transfer') {
      return 'Transfer to Account';
    } else if (transaction['transactionType'] == 'Bill Payment') {
      return 'Bill Payment';
    }
  } else {
    // For incoming
    if (transaction['transactionType'] == 'Fund Transfer') {
      return 'Transfer from Account';
    } else if (transaction['transactionType'] == 'Deposit') {
      return 'Deposit';
    }
  }

  // Default fallback
  return transaction['transactionType'] ?? 'Transaction';
}
