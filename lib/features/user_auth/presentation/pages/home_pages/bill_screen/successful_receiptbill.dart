import 'package:flutter/material.dart';
import 'dart:async';

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
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _startEllipsisAnimation();

    Timer(Duration(seconds: 4), () {
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

  void _startEllipsisAnimation() {
    int dotCount = 0;
    timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        dotCount = (dotCount + 1) % 4;
        dots = '.' * dotCount;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Color(0xFF015C4B),
              padding: EdgeInsets.symmetric(vertical: 20),
              width: double.infinity,
              child: Center(
                child: Text(
                  'One Step Away - Secure and Reliable!',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 40),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  Text(
                    'Processing your ₱${widget.amount} payment to ${widget.billerName} on ${widget.paymentDate}$dots',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    '₱ ${widget.amount}',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  Text('Total Amount'),
                  Divider(height: 30),
                  _infoRow("Transaction Date", widget.paymentDate),
                  _infoRow("Payment Method", "Personal Savings | Emerald"),
                  _infoRow("From", widget.accountHolder),
                  _infoRow("To", widget.billerName),
                  _infoRow("Reference Number", "REF20250221XZA145"),
                  SizedBox(height: 10),
                  _infoRow("Amount", "₱ ${widget.amount}"),
                  _infoRow("Penalties", "₱ 0.00"),
                  _infoRow("Fee", "₱ 10.00"),
                  SizedBox(height: 10),
                  Text(
                    'Emerald Bank',
                    style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (_) => Dot(color: Colors.green.shade800)),
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

class Dot extends StatelessWidget {
  final Color color;
  Dot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 10),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class SuccessfulReceiptBillPage extends StatelessWidget {
  final String billerName;
  final String accountHolder;
  final String amount;
  final String paymentDate;

  const SuccessfulReceiptBillPage({
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
        title: Text("Payment Successful"),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 40),
            Icon(Icons.check_circle, color: Colors.green, size: 80),
            SizedBox(height: 20),
            Text(
              "Payment Successful!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text("₱ $amount", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            Text("has been sent to $billerName"),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoRow("Transaction Date", paymentDate),
                    _infoRow("From", "Juzzthyn Perez"),
                    _infoRow("To", billerName),
                    _infoRow("Reference Number", "REF20250421XZA145"),
                    _infoRow("Amount", "₱ $amount"),
                    _infoRow("Fee", "₱ 10.00"),
                  ],
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF015C4B),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text("Back to Home", style: TextStyle(color: Colors.white)),
              ),
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