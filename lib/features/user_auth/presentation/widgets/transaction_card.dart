import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emeraldbank_mobileapp/utils/formatting_utils.dart';
import 'package:flutter/material.dart';

class TransactionCard extends StatelessWidget {
  final Map<String, dynamic> transaction;
  final String? accountId;
  final Function(Map<String, dynamic>)? onTap;

  const TransactionCard({
    super.key,
    required this.transaction,
    this.accountId,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final amount = toDouble(transaction['amount']);
    final fee = toDouble(transaction['fee'] ?? 0);
    final totalAmount = amount + fee;

    final transactionDate = transaction['transactionDate'] as Timestamp?;
    final dateString = formatTransactionDateRecent(transactionDate);

    final sourceRef = transaction['source']?['sourceRef'];
    final sourceRefPath =
        sourceRef is DocumentReference ? sourceRef.path : sourceRef.toString();

    final destinationRef = transaction['destination']?['destinationRef'];
    final destinationRefPath =
        destinationRef is DocumentReference
            ? destinationRef.path
            : destinationRef.toString();

    final currentAccountPath = _getCurrentAccountPath();

    final isOutgoing = sourceRefPath.contains(currentAccountPath);
    final isIncoming = destinationRefPath.contains(currentAccountPath);

    String amountPrefix;
    Color amountColor;

    if (isOutgoing && !isIncoming) {
      // Money leaving this account
      amountPrefix = '- ';
      amountColor = const Color(0xFFEB5757);
    } else if (!isOutgoing && isIncoming) {
      // Money coming into this account
      amountPrefix = '+ ';
      amountColor = const Color(0xFF06D6A0);
    } else if (isOutgoing && isIncoming) {
      // Internal transfer between own accounts
      amountPrefix = '~ ';
      amountColor = Colors.orange;
    } else {
      // Neither source nor destination matches account (shouldn't happen)
      amountPrefix = '';
      amountColor = Colors.grey;
    }

    final partnerName = getTransactionPartnerName(transaction, isOutgoing);
    final iconData = getTransactionIcon(transaction['transactionType']);

    return Card(
      elevation: 0,
      color: Colors.transparent,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () {
          if (onTap != null) {
            onTap!(transaction);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Transaction ID: ${transaction['id']}'),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(8),

        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
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
                    child: Icon(
                      iconData,
                      color: const Color(0xFF044E42),
                      size: 20,
                    ),
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
        ),
      ),
    );
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
