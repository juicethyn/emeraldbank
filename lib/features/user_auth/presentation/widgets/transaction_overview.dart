import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emeraldbank_mobileapp/utils/formatting_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionOverview extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;
  final VoidCallback? onViewAllPressed;
  final bool isLoading;
  final String? accountId;

  const TransactionOverview({
    super.key,
    required this.transactions,
    this.onViewAllPressed,
    this.isLoading = false,
    this.accountId,
  });

  @override
  Widget build(BuildContext context) {
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
                    'view all',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      height: 15 / 12,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: CircularProgressIndicator(color: Color(0xFF06D6A0)),
              ),
            )
          else if (transactions.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
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
          else
            Column(
              children:
                  transactions.map((transaction) {
                    return _buildTransactionCard(transaction);
                  }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> transaction) {
    final amount = toDouble(transaction['amount']);
    final fee = toDouble(transaction['fee'] ?? 0);
    final totalAmount = amount + fee;

    final transactionDate = transaction['transactionDate'] as Timestamp?;
    final dateString = _formatTransactionDate(transactionDate);

    // Get source and destination as strings for reliable comparison
    final sourceRef = transaction['source']?['sourceRef'];
    final sourceRefPath =
        sourceRef is DocumentReference ? sourceRef.path : sourceRef.toString();

    final destinationRef = transaction['destination']?['destinationRef'];
    final destinationRefPath =
        destinationRef is DocumentReference
            ? destinationRef.path
            : destinationRef.toString();

    // Get current account path
    final currentAccountPath = _getCurrentAccountPath();

    print('DEBUG: Current account path: $currentAccountPath');
    print('DEBUG: Source path: $sourceRefPath');
    print('DEBUG: Destination path: $destinationRefPath');

    // Check if this account is the source (money going out)
    final isOutgoing = sourceRefPath.contains(currentAccountPath);
    final isIncoming = destinationRefPath.contains(currentAccountPath);

    print('DEBUG: Is outgoing: $isOutgoing, Is incoming: $isIncoming');

    // Apply correct prefix and color
    final amountPrefix = isOutgoing ? '- ' : '+ ';
    final amountColor =
        isOutgoing
            ? const Color(0xFFEB5757) // Red for outgoing
            : const Color(0xFF06D6A0); // Green for incoming

    final partnerName = _getTransactionPartnerName(transaction, isOutgoing);
    final iconData = _getTransactionIcon(transaction['transactionType']);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFE6E6E6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(iconData, color: const Color(0xFF044E42), size: 20),
              ),

              const SizedBox(width: 12),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    partnerName,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      height: 15 / 12,
                      color: Color(0xFF1A1819),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateString,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
                      height: 12 / 10,
                      color: Color(0xCC1A1819),
                    ),
                  ),
                ],
              ),
            ],
          ),

          Text(
            '$amountPrefix${formatCurrency(totalAmount.abs())}',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              fontSize: 14,
              height: 17 / 14,
              color: amountColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _formatTransactionDate(Timestamp? timestamp) {
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

  String _getTransactionPartnerName(
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

  IconData _getTransactionIcon(String? transactionType) {
    switch (transactionType) {
      case 'Fund Transfer':
        return Icons.swap_horiz;
      case 'Bill Payment':
        return Icons.receipt_long;
      case 'Withdrawal':
        return Icons.money_off;
      case 'Deposit':
        return Icons.savings;
      case 'Payment':
        return Icons.payment;
      default:
        return Icons.account_balance_wallet;
    }
  }

  String _getCurrentAccountPath() {
    if (accountId == null) return '';
    if (accountId!.startsWith('/')) {
      return accountId!;
    } else {
      return 'savings/$accountId';
    }
  }
}
