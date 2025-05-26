import 'package:emeraldbank_mobileapp/features/user_auth/presentation/pages/home_pages/send_screen/sent_screen.dart';
import 'package:emeraldbank_mobileapp/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConfirmationPage extends StatelessWidget {
  final UserModel? user;
  final double amount;
  final String purpose;
  final String fromAccount;
  final String toAccount;

  const ConfirmationPage({
    super.key,
    this.user,
    required this.amount,
    required this.purpose,
    required this.fromAccount,
    required this.toAccount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          'Send | Own Account | Confirmation',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Confirmation',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00C191),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '₱',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF006D4F),
                  ),
                ),
                Text(
                  amount.toStringAsFixed(2), // Dynamically display the amount
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF006D4F),
                  ),
                ),
              ],
            ),
            Container(
              width: 200,
              height: 2,
              color: const Color(0xFF006D4F),
              margin: const EdgeInsets.symmetric(horizontal: 8),
            ),
            const SizedBox(height: 10),
            Text(
              'Your new balance will be ₱${(user!.balance - amount).toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 30),
            buildSectionTitle('Send to'),
            buildAccountCard(
              isGreen: true,
              accountName: "Emerald Bank",
              cardType: "Debit Card",
              accountNumber: "4363 1234 5678 9101",
              holderName: "JOHN MARK MAGSAYSAY",
              expiryDate: "09/2025",
              onChangePressed: () {
                // Handle change account
              },
            ),
            const SizedBox(height: 20),
            buildSectionTitle('From'),
            buildAccountCard(
              isGreen: false,
              accountName: "Emerald Bank",
              cardType: "Debit Card",
              accountNumber: "4363 1234 5678 9101",
              holderName: "JOHN MARK MAGSAYSAY",
              expiryDate: "09/2025",
              onChangePressed: () {
                // Handle change account
              },
            ),
            const SizedBox(height: 20),
            buildCVVField(),
            const SizedBox(height: 20),
            buildTransactionFeeSection(),
            const SizedBox(height: 30),
            buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildAccountCard({
    required bool isGreen,
    required String accountName,
    required String cardType,
    required String accountNumber,
    required String holderName,
    required String expiryDate,
    required VoidCallback onChangePressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Card display
          Container(
            width: 160,
            height: 100,
            decoration: BoxDecoration(
              color: isGreen ? const Color(0xFF006D4F) : Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.account_balance,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            accountName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      'VISA',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  accountNumber,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'EXPIRES ${expiryDate.split('/')[0]}/${expiryDate.split('/')[1].substring(2, 4)}',
                      style: const TextStyle(color: Colors.white, fontSize: 8),
                    ),
                    const Icon(Icons.wifi, color: Colors.white, size: 14),
                  ],
                ),
                Text(
                  holderName,
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Card info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cardType,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    const Text(
                      'MasterCard',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(width: 4),
                    Image.asset(
                      'assets/mastercard_logo.png',
                      width: 20,
                      height: 20,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.credit_card,
                            size: 12,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: onChangePressed,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 20),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Change',
                    style: TextStyle(
                      color: Color(0xFF00C191),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCVVField() {
    return Row(
      children: [
        const Text(
          'Enter CVV',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 12),
        Container(
          width: 100,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const TextField(
            obscureText: true,
            keyboardType: TextInputType.number,
            maxLength: 3,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              counterText: '',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTransactionFeeSection() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Transaction Fee',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '₱0.00',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Please double-check the transaction details before proceeding.',
            style: TextStyle(fontSize: 14),
          ),
          const Text('Ensure that:', style: TextStyle(fontSize: 14)),
          const SizedBox(height: 4),
          buildCheckItem(
            "The recipient's name and contact number are correct.",
          ),
          buildCheckItem(
            "The amount is accurate and within your available balance.",
          ),
          buildCheckItem("You have reviewed any applicable fees (if any)."),
          buildCheckItem("You are sending money to a trusted recipient."),
        ],
      ),
    );
  }

  Widget buildCheckItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 3),
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: const Color(0xFF00C191),
              borderRadius: BorderRadius.circular(2),
            ),
            child: const Icon(Icons.check, size: 12, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Color(0xFF00C191)),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF5350),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () {
              Navigator.pop(context); // Navigate back to the previous page
            },
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00503C),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () async {
              try {
                // Query the savings document where `accountHolder` matches the user's document path
                final savingsQuerySnapshot = await FirebaseFirestore.instance
                    .collection('savings')
                    .where('accountHolder', isEqualTo: "users/${user!.uid}") // Match the user's document path
                    .get();

                if (savingsQuerySnapshot.docs.isNotEmpty) {
                  // Get the first matching savings document
                  final savingsDocRef = savingsQuerySnapshot.docs.first.reference;

                  // Calculate the new balance
                  double newBalance = user!.balance - amount;

                  // Update the `currentBalance` in the `savingsAccountInformation` field
                  await savingsDocRef.update({
                    'currentBalance': newBalance,
                  });

                  // Navigate to the ReceiptPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReceiptPage(
                        amount: amount,
                        purpose: purpose,
                        fromAccount: fromAccount,
                        toAccount: toAccount,
                        newBalance: newBalance,
                      ),
                    ),
                  );
                } else {
                  // Handle case where no matching savings document is found
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No savings account found for the user.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } catch (e) {
                // Handle errors (e.g., network issues)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to complete the transaction: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text(
              'Submit',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}