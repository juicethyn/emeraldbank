import 'package:flutter/material.dart';
import 'processing_receiptbill.dart';

class ConfirmationReceiptBillPage extends StatelessWidget {
  final String billerName;
  final String accountHolder;
  final String amount;
  final String paymentDate;

  const ConfirmationReceiptBillPage({
    required this.billerName,
    required this.accountHolder,
    required this.amount,
    required this.paymentDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Color(0xFF015C4B),
        title: Text("Confirm Payment"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow("Biller", billerName),
                  _infoRow("Account Holder", accountHolder),
                  _infoRow("Amount", "₱ $amount"),
                  _infoRow("Date", paymentDate),
                  SizedBox(height: 20),
                  Text(
                    "Are you sure you want to proceed with this payment?",
                    style: TextStyle(color: Colors.grey.shade800),
                  ),
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProcessingReceiptBillPage(
                        billerName: billerName,
                        accountHolder: accountHolder,
                        amount: amount,
                        paymentDate: paymentDate,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF015C4B),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text("Confirm and Pay"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade700)),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
