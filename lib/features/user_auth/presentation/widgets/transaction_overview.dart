import 'package:emeraldbank_mobileapp/features/user_auth/presentation/widgets/transaction_card.dart';
import 'package:flutter/material.dart';

class TransactionOverview extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;
  final VoidCallback? onViewAllPressed;
  final bool isLoading;
  final String? accountId;
  final Function(Map<String, dynamic>)? onTransactionTap;

  const TransactionOverview({
    super.key,
    required this.transactions,
    this.onViewAllPressed,
    this.isLoading = false,
    this.accountId,
    this.onTransactionTap,
  });

  @override
  Widget build(BuildContext context) {
    // Limit transactions to 4 for overview
    final limitedTransactions = transactions.take(4).toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(51), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with "Recent Transactions" and "view all" link
          Container(
            padding: const EdgeInsets.only(bottom: 12),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(width: 1, color: Colors.black)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Transactions',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    height: 17 / 14,
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: onViewAllPressed,
                  child: const Text(
                    'View all',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      height: 15 / 12,
                      color: Color(0xFF028A6E),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Loading indicator or empty state
          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: CircularProgressIndicator(color: Color(0xFF06D6A0)),
              ),
            )
          else if (limitedTransactions.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'No Transactions Yet',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ),
            )
          // Reuse TransactionCard for each transaction
          else
            Column(
              children:
                  limitedTransactions.map((transaction) {
                    return TransactionCard(
                      transaction: transaction,
                      accountId: accountId,
                      onTap:
                          onTransactionTap != null
                              ? (tx) => onTransactionTap!(tx)
                              : null,
                    );
                  }).toList(),
            ),
        ],
      ),
    );
  }
}
