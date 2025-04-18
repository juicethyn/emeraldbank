import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/pages/main/addingAccounts/addingaccountcreditcards_page.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/styles/accountspage_appbar.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/styles/color_style.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/widgets/account_card_accountspages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreditcardPage extends StatefulWidget {
  const CreditcardPage({super.key});

  @override
  _CreditcardPageState createState() => _CreditcardPageState();
}

class _CreditcardPageState extends State<CreditcardPage> {
  bool _eyeEnabled = false;
  bool _isLoading = true;
  List<Map<String, dynamic>> _creditCards = [];

  @override
  void initState() {
    super.initState();
    _fetchCreditCardData();
  }

  void _toggleEye() {
    setState(() {
      _eyeEnabled = !_eyeEnabled;
    });
  }

  Future<void> _fetchCreditCardData() async {
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

      // Get Account References
      final accountRefsSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('accountReferences')
              .limit(1)
              .get();

      if (accountRefsSnapshot.docs.isEmpty) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Get Credit Card References
      final accountRefsDoc = accountRefsSnapshot.docs.first;
      final data = accountRefsDoc.data();
      final creditCardRefs = data['creditCardAccounts'] as List?;

      if (creditCardRefs == null ||
          creditCardRefs.isEmpty ||
          creditCardRefs.first == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Process Each Credit Card
      final cards = <Map<String, dynamic>>[];

      for (final ref in creditCardRefs) {
        if (ref == null) continue;

        // After getting the creditCardRefs
        print("Credit card refs: ${creditCardRefs?.length}");
        print("First ref: ${creditCardRefs?.first}");

        // When processing each ref
        print("Processing ref: $ref");
        print("Ref type: ${ref.runtimeType}");

        final String refPath =
            ref is DocumentReference ? ref.path : ref.toString();
        print("Using path: $refPath");

        // Get Credit Card Document using Reference
        final creditCardDoc =
            await FirebaseFirestore.instance.doc(refPath).get();

        if (!creditCardDoc.exists) continue;

        final cardData = creditCardDoc.data()!;

        // Get Account Type Details
        final accountTypeRef = cardData['creditCardInformation']['accountType'];
        String cardTypeName = "Credit Card";
        if (accountTypeRef != null) {
          try {
            if (accountTypeRef is DocumentReference) {
              final accountTypeDoc = await accountTypeRef.get();
              if (accountTypeDoc.exists) {
                final data = accountTypeDoc.data() as Map<String, dynamic>;
                cardTypeName = data['name'] ?? 'Credit Card';
              }
            }
          } catch (e) {
            print('Error fetching account type: $e');
          }
        }

        // Get Bank Details
        final bankRef = cardData['creditCardInformation']['associatedBank'];
        String bankName = "Bank";
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
            print('Error fetching account type: $e');
          }
        }

        // Extracting remaining essential details
        final remainingCredit = (cardData['remainingCredit'] ?? 0).toDouble();
        final creditLimit = (cardData['creditLimit'] ?? 0).toDouble();
        final billingDueDate =
            cardData['currentBilling']?['billingDueDate'] ?? 'N/A';

        cards.add({
          'balance': remainingCredit,
          'limit': creditLimit,
          'accountType': cardTypeName,
          'secondDetail': 'Billing Due: $billingDueDate',
          'thirdDetail': 'Balance ₱ ${remainingCredit.toStringAsFixed(2)}',
          'bankName': bankName,
          'docId': creditCardDoc.id,
        });
      }

      setState(() {
        _creditCards = cards;
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
        title: 'Credit Card',
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
                    builder: (context) => const AddingAccountCreditCardsPage(),
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
              : _creditCards.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'No Credit Cards Found',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF044E42),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Tap the + button to add a credit card",
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
                      ..._creditCards.map(
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
    );
  }
}
