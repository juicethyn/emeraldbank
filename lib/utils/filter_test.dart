enum DateRange { last7Days, last30Days, last3Months, allTime, custom }

enum TransactionDirection { all, incoming, outgoing }

class TransactionFilters {
  final DateRange dateRange;
  final TransactionDirection direction;
  final String? type;
  final double? minAmount;
  final double? maxAmount;

  TransactionFilters({
    this.dateRange = DateRange.allTime,
    this.direction = TransactionDirection.all,
    this.type,
    this.minAmount,
    this.maxAmount,
  });

  TransactionFilters copyWith({
    DateRange? dateRange,
    TransactionDirection? direction,
    String? type,
    double? minAmount,
    double? maxAmount,
    bool clearType = false,
  }) {
    return TransactionFilters(
      dateRange: dateRange ?? this.dateRange,
      direction: direction ?? this.direction,
      type: clearType ? null : (type ?? this.type),
      minAmount: minAmount ?? this.minAmount,
      maxAmount: maxAmount ?? this.maxAmount,
    );
  }

  bool get hasActiveFilters =>
      dateRange != DateRange.allTime ||
      direction != TransactionDirection.all ||
      type != null ||
      minAmount != null ||
      maxAmount != null;
}
