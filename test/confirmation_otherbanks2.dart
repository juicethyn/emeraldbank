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
      if (widget.user?.uid != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.user!.uid)
            .get();

        final userData = userDoc.data();
        if (userData == null) {
          print('No user data found');
          return;
        }

        final accountReferences = userData['accountReferences'];
        if (accountReferences == null) {
          print('No accountReferences found');
          return;
        }

        final List<dynamic>? savingsAccounts = accountReferences['savingsAccounts'];
        if (savingsAccounts == null || savingsAccounts.isEmpty) {
          print('No savingsAccounts found');
          return;
        }

        final firstSavingsRef = savingsAccounts.first;
        if (firstSavingsRef is! DocumentReference) {
          print('First savings account is not a DocumentReference: $firstSavingsRef');
          return;
        }

        final savingsDoc = await firstSavingsRef.get();
        final savingsData = savingsDoc.data() as Map<String, dynamic>?;

        if (savingsData != null) {
          setState(() {
            userBalance = (savingsData['currentBalance'] ?? 0.0).toDouble();
          });
        } else {
          print('No savings data found for reference');
        }
      }
    } catch (e) {
      print('Error fetching balance: $e');
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

                // Query the sender's first savings account
                final senderSavingsQuery = await FirebaseFirestore.instance
                    .collection('savings')
                    .where('accountHolder', isEqualTo: "users/${widget.user!.uid}")
                    .get();

                if (senderSavingsQuery.docs.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No savings account found for the sender.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                final senderDoc = senderSavingsQuery.docs.first;
                final senderData = senderDoc.data();

                String? senderAccountNumber;
                if (senderData.containsKey('savingsAccountInformation') &&
                    senderData['savingsAccountInformation'] != null &&
                    senderData['savingsAccountInformation']['accountNumber'] != null) {
                  senderAccountNumber = senderData['savingsAccountInformation']['accountNumber'];
                } else if (senderData['accountNumber'] != null) {
                  senderAccountNumber = senderData['accountNumber'];
                } else {
                  senderAccountNumber = '';
                }

                double senderBalance = userBalance ?? 0.0;

                // Check balance
                if (amount > senderBalance) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Insufficient balance'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                // Deduct from sender
                double newSenderBalance = senderBalance - amount;
                await senderDoc.reference.update({'currentBalance': newSenderBalance});
                setState(() {
                  userBalance = newSenderBalance;
                });

                // Query the recipient's savings account by accountNumber
                final recipientQuery = await FirebaseFirestore.instance
                    .collection('savings')
                    .where('savingsAccountInformation.accountNumber', isEqualTo: _accountNumberController.text)
                    .get();

                if (recipientQuery.docs.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Recipient account not found.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                final recipientDoc = recipientQuery.docs.first;
                final recipientData = recipientDoc.data();
                double recipientBalance = (recipientData['currentBalance'] ?? 0.0).toDouble();

                // Add to recipient
                double newRecipientBalance = recipientBalance + amount;
                await recipientDoc.reference.update({'currentBalance': newRecipientBalance});

                // Log the transaction
                await FirebaseFirestore.instance.collection('transactions').add(
                  {
                    'source': {
                      'sourceRef': senderDoc.reference,
                      'accountNumber': senderAccountNumber,
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
                  },
                );

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
                      fromAccount: senderAccountNumber ?? '',
                      toAccount: _accountNumberController.text,
                      newBalance: newSenderBalance,
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