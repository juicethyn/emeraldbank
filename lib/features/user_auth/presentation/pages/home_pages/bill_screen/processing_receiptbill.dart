import 'package:flutter/material.dart';
import 'dart:async';
import 'successful_receiptbill.dart';

class ProcessingReceiptBillPage extends StatefulWidget {
  final String billerName;
  final String accountHolder;
  final String amount;
  final String paymentDate;

  const ProcessingReceiptBillPage({
    required this.billerName,
    required this.accountHolder,
    required this.amount,
    required this.paymentDate,
  });

  @override
  _ProcessingReceiptBillPageState createState() => _ProcessingReceiptBillPageState();
}

class _ProcessingReceiptBillPageState extends State<ProcessingReceiptBillPage> {
  String dots = '';
  Timer? dotTimer;

  @override
  void initState() {
    super.initState();

    // Animate dots
    dotTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() => dots = '.' * ((dots.length + 1) % 4));
    });

    // Redirect to SuccessfulReceiptBillPage after 4 seconds
    Future.delayed(Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SuccessfulReceiptBillPage(
            billerName: widget.billerName,
            accountHolder: widget.accountHolder,
            amount: widget.amount,
            paymentDate: widget.paymentDate,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    dotTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Color(0xFF015C4B),
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text(
                  "One Step Away - Secure and Reliable!",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 30),
                  padding: EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Text(
                        "Your Payment is Being Process$dots",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "₱ ${widget.amount}",
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      Text("Total Amount"),
                      Divider(height: 30),
                      _infoRow("Transaction Date", widget.paymentDate),
                      _infoRow("Payment Method", "Personal Savings | Emerald"),
                      _infoRow("From", widget.accountHolder),
                      _infoRow("To", widget.billerName),
                      _infoRow("Reference Number", "REF20250421XZA145"),
                      SizedBox(height: 10),
                      _infoRow("Amount", "₱ ${widget.amount}"),
                      _infoRow("Penalties", "₱ 0.00"),
                      _infoRow("Fee", "₱ 10.00"),
                      SizedBox(height: 10),
                      Text(
                        "Emerald Bank",
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child: CircularProgressIndicator(
                    color: Color(0xFF015C4B),
                    strokeWidth: 3,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade700)),
          Text(value, style: TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
