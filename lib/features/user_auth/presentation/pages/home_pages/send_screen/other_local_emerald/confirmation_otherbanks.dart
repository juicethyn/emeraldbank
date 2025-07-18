import 'package:emeraldbank_mobileapp/features/user_auth/presentation/pages/home_pages/send_screen/sent_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/pages/home_pages/send_screen/own_account_screen/send_transfer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emeraldbank_mobileapp/models/user_model.dart';

class OwnAccountConfirmationPage extends StatefulWidget {
  const OwnAccountConfirmationPage({super.key, required this.user});

  final UserModel? user;

  @override
  State<OwnAccountConfirmationPage> createState() =>
      _OwnAccountConfirmationPageState();
}

class _OwnAccountConfirmationPageState
    extends State<OwnAccountConfirmationPage> {
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  final TextEditingController _purposeController = TextEditingController();

  // Add balance variable
  double? userBalance;

  void _clearAllFields() {
    setState(() {
      _accountNameController.clear();
      _accountNumberController.clear();
      _amountController.clear();
      _contactNumberController.clear();
      _purposeController.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchUserBalance();
  }

  // Add method to fetch balance
  Future<void> _fetchUserBalance() async {
    try {
      final accNum = widget.user?.accountNumber ?? '';
      if (accNum.isEmpty) return;

      final querySnapshot = await FirebaseFirestore.instance
          .collection('savings')
          .where('savingsAccountInformation.accountNumber', isEqualTo: accNum)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final savingsData = querySnapshot.docs.first.data();
        setState(() {
          userBalance = (savingsData['currentBalance'] ?? 0.0).toDouble();
        });
      } else {
        setState(() {
          userBalance = 0.0;
        });
      }
    } catch (e) {
      print('Error fetching balance: $e');
      setState(() {
        userBalance = 0.0;
      });
    }
  }

  @override
  void dispose() {
    _accountNameController.dispose();
    _accountNumberController.dispose();
    _amountController.dispose();
    _contactNumberController.dispose();
    _purposeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FFF8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const SendTransferScreen(user: null),
              ),
            );
          },
        ),
        title: const Text(
          'Send | Own Account | Confirmation',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Emerald Accounts',
              style: TextStyle(
                color: Color(0xFF00C191),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            buildSendFromCard(),
            const SizedBox(height: 30),
            buildInputField(
              title: "Account Name",
              controller: _accountNameController,
              trailing: TextButton(
                onPressed: _clearAllFields,
                child: const Text("Clear", style: TextStyle(color: Colors.red)),
              ),
            ),
            const SizedBox(height: 12),
            buildInputField(
              title: "Account Number *",
              hint: "Enter the account number",
              controller: _accountNumberController,
              isNumberOnly: true,
            ),
            const SizedBox(height: 12),
            buildInputField(
              title: "Amount *",
              hint: "Enter the amount",
              controller: _amountController,
              isNumberOnly: true,
            ),
            const SizedBox(height: 12),
            buildInputField(
              title: "Contact Number *",
              hint: "Insert your contact number ",
              controller: _contactNumberController,
              isNumberOnly: true,
            ),
            const SizedBox(height: 12),
            buildPurposeField(),
            const SizedBox(height: 30),
            buildBottomButtons(context),
          ],
        ),
      ),
    );
  }

  Widget buildSendFromCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5FFFA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Card Mock
          Container(
            width: 140,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Savings',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
                Spacer(),
                Text(
                  '4363 1234 5678 9101',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                Text(
                  'JOHN MARK MAGSAYSAY',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Debit Card',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text(
                      'MasterCard',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.credit_card,
                      size: 16,
                      color: Colors.orange.shade700,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Change',
                    style: TextStyle(
                      color: Color(0xFF00C191),
                      fontWeight: FontWeight.bold,
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

  Widget buildInputField({
    required String title,
    String? hint,
    String? bottomNote,
    Widget? trailing,
    TextEditingController? controller,
    bool isNumberOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            if (trailing != null) trailing,
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType:
              isNumberOnly ? TextInputType.number : TextInputType.text,
          inputFormatters:
              isNumberOnly ? [FilteringTextInputFormatter.digitsOnly] : null,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
          ),
        ),
        if (title == "Amount *") ...[
          const SizedBox(height: 4),
          Text(
            "You have a current balance of ₱${userBalance?.toStringAsFixed(2) ?? '0.00'}",
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
        if (bottomNote != null) ...[
          const SizedBox(height: 4),
          Text(
            bottomNote,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ],
    );
  }

  Widget buildPurposeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Purpose of transaction (Optional)",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _purposeController, // Add this line
          maxLines: 4,
          maxLength: 200,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildBottomButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF5350),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              try {
                // Validate inputs
                if (_accountNumberController.text.isEmpty ||
                    _amountController.text.isEmpty ||
                    _contactNumberController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill all required fields'),
                    ),
                  );
                  return;
                }

                double amount = double.parse(_amountController.text);

                // Check sender's balance
                if (amount > (userBalance ?? 0)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Insufficient balance'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                // 1. Deduct from sender
                final senderQuery = await FirebaseFirestore.instance
                    .collection('savings')
                    .where('savingsAccountInformation.accountNumber', isEqualTo: widget.user!.accountNumber)
                    .get();

                if (senderQuery.docs.isEmpty) {
                  throw Exception('Sender account not found');
                }
                final senderDoc = senderQuery.docs.first.reference;
                final senderData = senderQuery.docs.first.data();
                double senderNewBalance = (senderData['currentBalance'] ?? 0.0).toDouble() - amount;
                await senderDoc.update({'currentBalance': senderNewBalance});

                // 2. Credit to recipient
                final recipientQuery = await FirebaseFirestore.instance
                    .collection('savings')
                    .where('savingsAccountInformation.accountNumber', isEqualTo: _accountNumberController.text)
                    .get();

                if (recipientQuery.docs.isEmpty) {
                  throw Exception('Recipient account not found');
                }
                final recipientDoc = recipientQuery.docs.first.reference;
                final recipientData = recipientQuery.docs.first.data();
                double recipientNewBalance = (recipientData['currentBalance'] ?? 0.0).toDouble() + amount;
                await recipientDoc.update({'currentBalance': recipientNewBalance});

                // 3. Create transaction record
                await FirebaseFirestore.instance.collection('transactions').add({
                  'source': {
                    'sourceRef': senderDoc,
                    'accountNumber': widget.user!.accountNumber,
                  },
                  'destination': {
                    'accountNumber': _accountNumberController.text,
                  },
                  'amount': amount,
                  'fee': 0.0,
                  'purpose': _purposeController.text,
                  'transactionType': 'Fund Transfer',
                  'transactionDate': FieldValue.serverTimestamp(),
                  'status': 'completed',
                  'channelDetails': {'channelType': 'Mobile Banking'},
                });

                // Navigate to receipt page
                if (!context.mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReceiptPage(
                      amount: amount,
                      purpose: _purposeController.text.isNotEmpty
                          ? _purposeController.text
                          : 'No purpose specified',
                      fromAccount: widget.user!.accountNumber,
                      toAccount: _accountNumberController.text,
                      newBalance: senderNewBalance,
                    ),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to complete transaction: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00503C),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'Confirmation',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}