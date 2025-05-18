import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/pages/main/transactionPage/transaction_details.dart';
import 'package:emeraldbank_mobileapp/utils/filter_test.dart';
import 'package:emeraldbank_mobileapp/utils/formatting_utils.dart';
import 'package:flutter/material.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/styles/accountdetails_appbar.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/widgets/transaction_card.dart';
import 'package:rxdart/rxdart.dart';

class TransactionHistoryPage extends StatefulWidget {
  final String accountId;

  const TransactionHistoryPage({Key? key, required this.accountId})
    : super(key: key);

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  TransactionFilters _currentFilters = TransactionFilters();
  // Helper method to apply filters to transactions
  List<Map<String, dynamic>> _applyFilters(
    List<Map<String, dynamic>> transactions,
  ) {
    return transactions.where((tx) {
      // Apply date filter
      if (_currentFilters.dateRange != DateRange.allTime) {
        final txDate = (tx['transactionDate'] as Timestamp).toDate();
        final now = DateTime.now();
        final cutoffDate =
            _currentFilters.dateRange == DateRange.last7Days
                ? now.subtract(Duration(days: 7))
                : _currentFilters.dateRange == DateRange.last30Days
                ? now.subtract(Duration(days: 30))
                : now.subtract(Duration(days: 90)); // last3Months

        if (txDate.isBefore(cutoffDate)) {
          return false;
        }
      }

      // Apply direction filter
      if (_currentFilters.direction != TransactionDirection.all) {
        final accountRef = FirebaseFirestore.instance.doc(
          'savings/${widget.accountId}',
        );
        final sourceRef = tx['source']?['sourceRef'];
        final sourceRefPath =
            sourceRef is DocumentReference
                ? sourceRef.path
                : sourceRef.toString();

        // Compare with accountRef.path instead of widget.accountId
        final isOutgoing = sourceRefPath.contains(accountRef.path);

        if (_currentFilters.direction == TransactionDirection.incoming &&
            isOutgoing) {
          return false;
        }
        if (_currentFilters.direction == TransactionDirection.outgoing &&
            !isOutgoing) {
          return false;
        }
      }

      // Apply type filter
      if (_currentFilters.type != null &&
          tx['transactionType'] != _currentFilters.type) {
        return false;
      }

      // Apply amount filters
      final amount = toDouble(tx['amount']) + toDouble(tx['fee'] ?? 0);
      if (_currentFilters.minAmount != null &&
          amount < _currentFilters.minAmount!) {
        return false;
      }
      if (_currentFilters.maxAmount != null &&
          amount > _currentFilters.maxAmount!) {
        return false;
      }

      return true;
    }).toList();
  }

  Stream<List<Map<String, dynamic>>> _getTransactionsStream(String accountId) {
    final accountRef = FirebaseFirestore.instance.doc('savings/$accountId');

    final sourceStream =
        FirebaseFirestore.instance
            .collection('transactions')
            .where('source.sourceRef', isEqualTo: accountRef)
            .orderBy('transactionDate', descending: true)
            .snapshots();

    final destStream =
        FirebaseFirestore.instance
            .collection('transactions')
            .where('destination.destinationRef', isEqualTo: accountRef)
            .orderBy('transactionDate', descending: true)
            .snapshots();

    return Rx.combineLatest2(sourceStream, destStream, (
      QuerySnapshot sourceSnapshot,
      QuerySnapshot destSnapshot,
    ) {
      print(
        'DEBUG: Got ${sourceSnapshot.docs.length} source transactions and ${destSnapshot.docs.length} dest transactions',
      );

      // Process source transactions
      final sourceTxs =
          sourceSnapshot.docs
              .map(
                (doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>},
              )
              .toList();

      // Process destination transactions
      final destTxs =
          destSnapshot.docs
              .map(
                (doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>},
              )
              .toList();

      // Combine both lists
      final allTransactions = [...sourceTxs, ...destTxs];

      // Sort by date (newest first)
      allTransactions.sort((a, b) {
        final aDate = (a['transactionDate'] as Timestamp).toDate();
        final bDate = (b['transactionDate'] as Timestamp).toDate();
        return bDate.compareTo(aDate);
      });

      // Remove duplicates based on transaction id
      final uniqueTransactions = <String, Map<String, dynamic>>{};
      for (final tx in allTransactions) {
        uniqueTransactions[tx['id']] = tx;
      }

      final result = uniqueTransactions.values.toList();
      print('DEBUG: Returning ${result.length} combined transactions');
      return result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AccountDetailsAppbar(
        title: 'Transaction History',
        actions: [
          // Filter button with the same styling as back button
          Container(
            margin: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FFE5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.filter_list,
                color: Color(0xFF044E42),
                size: 18,
              ),
              onPressed: () {
                // Show filter dialog or bottom sheet
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder:
                      (context) => FilterBottomSheet(
                        initialFilters: _currentFilters,
                        onlyApplyFilters: (filters) {
                          setState(() {
                            _currentFilters = filters;
                          });
                        },
                      ),
                );
              },
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _getTransactionsStream(widget.accountId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF06D6A0)),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading transactions: ${snapshot.error}',
                style: const TextStyle(
                  color: Colors.red,
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                ),
              ),
            );
          }

          final transactions = _applyFilters(snapshot.data ?? []);

          if (transactions.isEmpty) {
            return const Center(
              child: Text(
                'No transactions found',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: transactions.length,
            separatorBuilder: (context, index) => const SizedBox(height: 4),
            itemBuilder: (context, index) {
              return TransactionCard(
                transaction: transactions[index],
                accountId: widget.accountId,
                onTap: (transaction) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => TransactionDetails(
                            transactionId: transaction['id'],
                            transactionData:
                                transaction, // Pass data to avoid another fetch
                          ),
                    ),
                  );

                  //   // Show a SnackBar with transaction ID
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     SnackBar(
                  //       content: Text('Transaction ID: ${transaction['id']}'),
                  //       duration: const Duration(seconds: 2),
                  //       action: SnackBarAction(
                  //         label: 'View Details',
                  //         onPressed: () {
                  //           // In future, navigate to details page
                  //           // Navigator.push(
                  //           //   context,
                  //           //   MaterialPageRoute(
                  //           //     builder: (context) => TransactionDetailsPage(
                  //           //       transactionId: transaction['id'],
                  //           //     ),
                  //           //   ),
                  //           // );
                  //         },
                  //       ),
                  //     ),
                  //   );
                },
              );
            },
          );
        },
      ),
    );
  }
}

// Simple implementation of FilterBottomSheet
class FilterBottomSheet extends StatefulWidget {
  final Function(TransactionFilters) onlyApplyFilters;
  final TransactionFilters initialFilters;

  const FilterBottomSheet({
    super.key,
    required this.onlyApplyFilters,
    required this.initialFilters,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late TransactionFilters _filters;

  @override
  void initState() {
    super.initState();
    _filters = widget.initialFilters;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 500, // Taller to fit all filters
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter Transactions',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF044E42),
            ),
          ),
          const SizedBox(height: 20),

          // Date Range Filter
          Text('Date Range', style: TextStyle(fontWeight: FontWeight.w600)),
          Wrap(
            spacing: 8,
            children: [
              _filterChip(
                'Last 7 days',
                _filters.dateRange == DateRange.last7Days,
                () => setState(
                  () =>
                      _filters = _filters.copyWith(
                        dateRange: DateRange.last7Days,
                      ),
                ),
              ),
              _filterChip(
                'Last 30 days',
                _filters.dateRange == DateRange.last30Days,
                () => setState(
                  () =>
                      _filters = _filters.copyWith(
                        dateRange: DateRange.last30Days,
                      ),
                ),
              ),
              _filterChip(
                'All time',
                _filters.dateRange == DateRange.allTime,
                () => setState(
                  () =>
                      _filters = _filters.copyWith(
                        dateRange: DateRange.allTime,
                      ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Transaction Direction
          Text(
            'Transaction Direction',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          Wrap(
            spacing: 8,
            children: [
              _filterChip(
                'All',
                _filters.direction == TransactionDirection.all,
                () => setState(
                  () =>
                      _filters = _filters.copyWith(
                        direction: TransactionDirection.all,
                      ),
                ),
              ),
              _filterChip(
                'Money In',
                _filters.direction == TransactionDirection.incoming,
                () => setState(
                  () =>
                      _filters = _filters.copyWith(
                        direction: TransactionDirection.incoming,
                      ),
                ),
              ),
              _filterChip(
                'Money Out',
                _filters.direction == TransactionDirection.outgoing,
                () => setState(
                  () =>
                      _filters = _filters.copyWith(
                        direction: TransactionDirection.outgoing,
                      ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Transaction Type
          Text(
            'Transaction Type',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          Wrap(
            spacing: 8,
            children: [
              _filterChip(
                'All Types',
                _filters.type == null,
                () => setState(
                  () => _filters = _filters.copyWith(clearType: true),
                ),
              ),
              _filterChip(
                'Transfers',
                _filters.type == 'Fund Transfer',
                () => setState(
                  () => _filters = _filters.copyWith(type: 'Fund Transfer'),
                ),
              ),
              _filterChip(
                'Bill Payments',
                _filters.type == 'Bill Payment',
                () => setState(
                  () => _filters = _filters.copyWith(type: 'Bill Payment'),
                ),
              ),
            ],
          ),

          const Spacer(),

          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  // Reset all filters
                  setState(() => _filters = TransactionFilters());
                },
                child: Text(
                  'Reset',
                  style: TextStyle(color: Color(0xFF044E42)),
                ),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Color(0xFF044E42)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF044E42),
                    ),
                    onPressed: () {
                      widget.onlyApplyFilters(
                        _filters,
                      ); // Fixed from onApplyFilters
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Apply',
                      style: TextStyle(color: Color(0xFFF8FFE5)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, bool isSelected, VoidCallback onTap) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: Color(0xFF06D6A0).withAlpha(51),
      checkmarkColor: Color(0xFF044E42),
    );
  }
}
