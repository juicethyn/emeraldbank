import 'package:cloud_firestore/cloud_firestore.dart';
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
                  builder: (context) => const FilterBottomSheet(),
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

          final transactions = snapshot.data ?? [];

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
                  // Show a SnackBar with transaction ID
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Transaction ID: ${transaction['id']}'),
                      duration: const Duration(seconds: 2),
                      action: SnackBarAction(
                        label: 'View Details',
                        onPressed: () {
                          // In future, navigate to details page
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => TransactionDetailsPage(
                          //       transactionId: transaction['id'],
                          //     ),
                          //   ),
                          // );
                        },
                      ),
                    ),
                  );
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
class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 300,
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
          // Filter options will go here
          const Text('Filter options coming soon...'),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF044E42),
                ),
                onPressed: () {
                  // Apply filters
                  Navigator.pop(context);
                },
                child: const Text('Apply'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
