import 'package:emeraldbank_mobileapp/features/user_auth/presentation/pages/main/main_navigation.dart';
import 'package:flutter/material.dart';

class TimeDepositReceipt extends StatelessWidget {
  final String referenceNumber;
  final String payFrom;
  final double depositAmount;
  final double interestRate;
  final String term;
  final double maturityAmount;
  final double maturityInterest;
  final String interestPayout;
  final String maturityDate;
  final String transactionDate;

  const TimeDepositReceipt({
    super.key,
    required this.referenceNumber,
    required this.payFrom,
    required this.depositAmount,
    required this.interestRate,
    required this.term,
    required this.maturityAmount,
    required this.maturityInterest,
    required this.interestPayout,
    required this.maturityDate,
    required this.transactionDate,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Disable system back button
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // Hide back button in AppBar
          title: Text(
            "Payment Receipt",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Receipt Card
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Color(0xFF06D6A0),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 40), // space for the checkmark
                        Text(
                          "Payment Complete",
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFF06D6A0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "₱ ${depositAmount.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 32,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Deposit Amount",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF06D6A0),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Divider(thickness: 1, color: Colors.grey.shade300),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                          child: Column(
                            children: [
                              _receiptRow("Transaction Date", transactionDate, highlight: true),
                              const SizedBox(height: 8),
                              _receiptRow("Pay From", payFrom, highlight: true),
                              const SizedBox(height: 8),
                              _receiptRow("Interest Rate", "${(interestRate * 100).toStringAsFixed(2)}%", highlight: true),
                              const SizedBox(height: 8),
                              _receiptRow("Term", term, highlight: true),
                              const SizedBox(height: 8),
                              _receiptRow("Reference Number", referenceNumber, highlight: true),
                              const SizedBox(height: 8),
                              Divider(thickness: 1, color: Colors.grey.shade300),
                              const SizedBox(height: 8),
                              _receiptRow("Maturity Amount", "₱ ${maturityAmount.toStringAsFixed(2)}"),
                              const SizedBox(height: 8),
                              _receiptRow("Maturity Interest", "₱ ${maturityInterest.toStringAsFixed(2)}"),
                              const SizedBox(height: 8),
                              _receiptRow("Interest Payout", interestPayout, highlight: true),
                              const SizedBox(height: 8),
                              _receiptRow("Maturity Date", maturityDate, highlight: true),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Emerald Bank",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF06D6A0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Dotted bottom (optional, for visual effect)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            12,
                            (index) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                  // Checkmark Circle
                  Positioned(
                    top: -32,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xFF06D6A0),
                            width: 3,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.check_circle,
                            color: Color(0xFF06D6A0),
                            size: 48,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MainNavigation()),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Color(0xFF06D6A0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      "Done",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for receipt rows
  Widget _receiptRow(String label, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 13,
                color: highlight ? Color(0xFF06D6A0) : Colors.black,
                fontWeight: highlight ? FontWeight.w600 : FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}