import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/pages/main/addingAccounts/addingaccountloans_page.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/styles/accountsPage_appbar.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/styles/color_style.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/widgets/account_card_accountspages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoansPage extends StatefulWidget {
  const LoansPage({super.key});

  @override
  _LoansPageState createState() => _LoansPageState();
}

class _LoansPageState extends State<LoansPage> {
  bool _eyeEnabled = false;
  bool _isLoading = true;
  List<Map<String, dynamic>> _loan = [];

  @override
  void initState() {
    super.initState();
    _fetchLoanData();
  }

  void _toggleEye() {
    setState(() {
      _eyeEnabled = !_eyeEnabled;
    });
  }

  Future<void> _fetchLoanData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      // Current User
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Get account references
      final accountRefsSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('accountReferences')
              .limit(1)
              .get();

      print("Account refs docs: ${accountRefsSnapshot.docs.length}");

      if (accountRefsSnapshot.docs.isEmpty) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Get Loan References
      final accountRefsDoc = accountRefsSnapshot.docs.first;
      final data = accountRefsDoc.data();
      final loanRefs = data['loanAccounts'] as List?;

      if (loanRefs == null || loanRefs.isEmpty || loanRefs.first == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final cards = <Map<String, dynamic>>[];

      // Process each loan accounts
      for (final ref in loanRefs) {
        if (ref == null) continue;

        // Get Loan Document Using References
        final String refPath =
            ref is DocumentReference ? ref.path : ref.toString();

        final loanDoc = await FirebaseFirestore.instance.doc(refPath).get();

        if (!loanDoc.exists) continue;

        final cardData = loanDoc.data()!;

        final accountTypeRef =
            cardData['loanAccountInformation']['accountType'];
        String cardTypeName = 'Loan Account';
        String billingType = 'Billing';
        if (accountTypeRef != null) {
          try {
            if (accountTypeRef is DocumentReference) {
              final accountTypeDoc = await accountTypeRef.get();
              if (accountTypeDoc.exists) {
                final data = accountTypeDoc.data() as Map<String, dynamic>;
                cardTypeName = data['name'] ?? 'Loan Account';
                billingType = data['billingType'] ?? 'Billing';
              }
            }
          } catch (e) {
            print('Error fetching account type: $e');
          }
        }

        // Get Bank Details
        final bankRef = cardData['loanAccountInformation']['associatedBank'];
        String bankName = 'Bank';
        if (bankRef != null) {
          if (bankRef != null) {
            try {
              if (bankRef is DocumentReference) {
                final bankRefDoc = await bankRef.get();
                if (bankRefDoc.exists) {
                  final data = bankRefDoc.data() as Map<String, dynamic>;
                  bankName = data['short_name'] ?? 'Bank';
                }
              }
            } catch (e) {
              print('Error Fetching account type: $e');
            }
          }
        }

        // Extract remaining essential details
        final loanBalance = (cardData['loanBalance'] ?? 0).toDouble();
        final totalLoan = (cardData['totalLoan'] ?? 0).toDouble();
        final billingDueDate =
            cardData['currentBilling']?['billingDueDate'] ?? 'N/A';
        final billingDue =
            (cardData['currentBilling']?['billingDue'] ?? 0).toDouble();
        final combinedBillingDueAndBillingType =
            '₱ ${billingDue.toStringAsFixed(2)} / $billingType';

        cards.add({
          'balance': loanBalance,
          'limit': totalLoan,
          'accountType': cardTypeName,
          'secondDetail': combinedBillingDueAndBillingType,
          'thirdDetail': 'Due Date: $billingDueDate',
          'bankName': bankName,
          'docId': loanDoc.id,
        });
      }
      setState(() {
        _loan = cards;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching credit card data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AccountsPageAppbar(
        title: 'Loans',
        onEyeToggle: _toggleEye,
        eyeEnabled: _eyeEnabled,
      ),

      floatingActionButton: Material(
        elevation: 8.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Ink(
          decoration: BoxDecoration(gradient: Customgradients.iconGradient),
          child: InkWell(
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddingAccountLoansPage(),
                  ),
                ),
            child: const SizedBox(
              width: 56,
              height: 56,
              child: Icon(Icons.add, size: 32.0, color: Colors.white),
            ),
          ),
        ),
      ),

      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF06D6A0)),
              )
              : _loan.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'No Loan/s Found',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF044E42),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Tap the + button to add a loan",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              )
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ..._loan.map(
                        (card) => Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: AccountCard(
                            balanceHolder: card['balance'],
                            limitBalanceHolder: card['limit'],
                            accountTypeHolder: card['accountType'],
                            secondDetail: card['secondDetail'],
                            thirdDetail: card['thirdDetail'],
                            associatedName: card['bankName'],
                            isHidden: !_eyeEnabled,
                            onTap: () {
                              // To be implemented
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(card['docId'])),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      // body: const Padding(
      //   padding: EdgeInsets.all(16.0),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Text(
      //         'Your Loans Accounts',
      //         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      //       ),
      //       // Add your savings account details here
      //     ],
      //   ),
      // ),
    );
  }
}
