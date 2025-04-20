import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReceiptPage extends StatelessWidget {
  final double amount;
  final String purpose;
  final String fromAccount;
  final String toAccount;
  final double newBalance;

  const ReceiptPage({
    Key? key,
    required this.amount,
    required this.purpose,
    required this.fromAccount,
    required this.toAccount,
    required this.newBalance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate = DateFormat('MM/dd/yyyy').format(now);
    final formattedTime = DateFormat('h:mma').format(now).toLowerCase();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Receipt'),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFe6f3ef),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Sent',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Icon(Icons.check_circle, color: Colors.green, size: 60),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRow('Amount Sent:', '₱${amount.toStringAsFixed(2)}'),
                    const SizedBox(height: 12),
                    _buildRow('Purpose:', purpose),
                    const SizedBox(height: 12),
                    _buildRow('From Account:', fromAccount),
                    const SizedBox(height: 12),
                    _buildRow('To Account:', toAccount),
                    const SizedBox(height: 12),
                    _buildRow('New Balance:', '₱${newBalance.toStringAsFixed(2)}'),
                    const SizedBox(height: 12),
                    _buildRow('Date Issued:', formattedDate),
                    const SizedBox(height: 12),
                    _buildRow('Time:', formattedTime),
                    const SizedBox(height: 20),
                    const Text(
                      'A confirmation receipt has been generated. You may check your transaction history for details. Thank you for using Emerald App!',
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/main"); // Navigate back to the previous page
                },
                child: const Text('Done'),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 15),
          ),
        ),
      ],
    );
  }
}
