import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/pages/main/addingAccounts/addingaccountsavings_page.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/pages/savings/savingsdetails_page.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/styles/accountsPage_appbar.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/styles/color_style.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/widgets/account_card_accountspages.dart';
import 'package:emeraldbank_mobileapp/utils/formatting_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SavingsPage extends StatefulWidget {
  const SavingsPage({super.key});

  @override
  _SavingsPageState createState() => _SavingsPageState();
}

class _SavingsPageState extends State<SavingsPage> {
  bool _eyeEnabled = false;
  bool _isLoading = true;
  List<Map<String, dynamic>> _savings = [];

  StreamSubscription<QuerySnapshot>? _savingsStreamSubscription;

  @override
  void initState() {
    super.initState();
    _setupSavingsListener();
  }

  @override
  void dispose() {
    _savingsStreamSubscription?.cancel();
    super.dispose();
  }

  void _toggleEye() {
    setState(() {
      _eyeEnabled = !_eyeEnabled;
    });
  }

  Future<Map<String, dynamic>?> _getLastTransaction(String accountId) async {
    try {
      // Get Transaction where this account is the source
      final outgoingQuery =
          await FirebaseFirestore.instance
              .collection('transactions')
              .where(
                'source.sourceRef',
                isEqualTo: FirebaseFirestore.instance.doc('savings/$accountId'),
              )
              .orderBy('transactionDate', descending: true)
              .limit(1)
              .get();

      // Get transactions where this account is the destination
      final incomingQuery =
          await FirebaseFirestore.instance
              .collection('transactions')
              .where(
                'destination.destinationRef',
                isEqualTo: FirebaseFirestore.instance.doc('savings/$accountId'),
              )
              .orderBy('transactionDate', descending: true)
              .limit(1)
              .get();

      // Comparing who is more recent
      final outgoingDoc =
          outgoingQuery.docs.isNotEmpty ? outgoingQuery.docs.first : null;
      final incomingDoc =
          incomingQuery.docs.isNotEmpty ? incomingQuery.docs.first : null;

      // No transactions
      if (outgoingDoc == null && incomingDoc == null) {
        return null;
      }
      DocumentSnapshot mostRecent;
      bool isIncoming = false;

      if (outgoingDoc == null) {
        mostRecent = incomingDoc!;
        isIncoming = true;
      } else if (incomingDoc == null) {
        mostRecent = outgoingDoc;
      } else {
        // Compare dates
        final outgoingDate = outgoingDoc['transactionDate'] as Timestamp;
        final incomingDate = incomingDoc['transactionDate'] as Timestamp;

        if (outgoingDate.compareTo(incomingDate) > 0) {
          mostRecent = outgoingDoc;
        } else {
          mostRecent = incomingDoc;
        }
      }

      // Format Transaction Date
      final txData = mostRecent.data() as Map<String, dynamic>;
      final amount = txData['amount'] as num;
      final fee = txData['fee'] as num;
      final date = txData['transactionDate'] as Timestamp;

      return {
        'amount': amount.toDouble(),
        'fee': fee,
        'date': date,
        'formattedDate': formatDateMMDDYYYY(date.toDate()),
        'type': txData['transactionType'] ?? 'TRANSACTION',
        'isIncoming': isIncoming,
      };
    } catch (e) {
      print('Error fetching last transaction: $e');
      return null;
    }
  }

  Future<void> _fetchSavingsData() async {
    // Simply call your existing setup method to refresh the data
    await _setupSavingsListener();
    return;
  }

  Future<void> _setupSavingsListener() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Listen to accountReferences document for changes
    _savingsStreamSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('accountReferences')
        .limit(1)
        .snapshots()
        .listen(
          (snapshot) async {
            if (snapshot.docs.isEmpty) {
              setState(() {
                _savings = [];
                _isLoading = false;
              });
              return;
            }

            final accountRefsDoc = snapshot.docs.first;
            final data = accountRefsDoc.data();
            final savingsRefs = data['savingsAccounts'] as List?;

            if (savingsRefs == null || savingsRefs.isEmpty) {
              setState(() {
                _savings = [];
                _isLoading = false;
              });
              return;
            }

            // Process each savings account
            try {
              final cards = <Map<String, dynamic>>[];

              for (final ref in savingsRefs) {
                if (ref == null) continue;

                final String refPath =
                    ref is DocumentReference ? ref.path : ref.toString();

                // Get savings document using reference
                final savingsDoc =
                    await FirebaseFirestore.instance.doc(refPath).get();

                if (!savingsDoc.exists) continue;
                final cardData = savingsDoc.data()!;

                // Get Account Type Details
                final accountTypeRef =
                    cardData['savingsAccountInformation']['accountType'];
                String cardTypeName = 'Savings Account';
                String? interestRate;
                if (accountTypeRef != null) {
                  try {
                    if (accountTypeRef is DocumentReference) {
                      final accountTypeDoc = await accountTypeRef.get();
                      if (accountTypeDoc.exists) {
                        final data =
                            accountTypeDoc.data() as Map<String, dynamic>;
                        cardTypeName = data['name'] ?? 'Savings Account';

                        if (data.containsKey('interestRate')) {
                          interestRate = formatInterestRateDisplay(
                            data['interestRate'],
                          );
                        }
                      }
                    }
                  } catch (e) {
                    print('Error fetching account type: $e');
                  }
                }

                // Get Bank Details
                final bankRef =
                    cardData['savingsAccountInformation']['associatedBank'];
                String bankName = 'Bank';
                if (bankRef != null) {
                  if (bankRef != null) {
                    try {
                      if (bankRef is DocumentReference) {
                        final bankRefDoc = await bankRef.get();
                        if (bankRefDoc.exists) {
                          final data =
                              bankRefDoc.data() as Map<String, dynamic>;
                          bankName = data['short_name'] ?? 'Bank';
                        }
                      }
                    } catch (e) {
                      print('Error Fetching account type: $e');
                    }
                  }
                }

                // Extracting remaining essential details
                final remainingBalance =
                    (cardData['currentBalance'] ?? 0).toDouble();
                final accountNumber =
                    (cardData['savingsAccountInformation']?['accountNumber'] ??
                        'N/A');

                final lastTransaction = await _getLastTransaction(
                  savingsDoc.id,
                );
                final lastTransactionText =
                    lastTransaction != null
                        ? '${lastTransaction['formattedDate']} (${lastTransaction['isIncoming'] ? '+' : '-'} ${formatCurrency(lastTransaction['amount'] + lastTransaction['fee'])})'
                        : 'No transaction history';

                cards.add({
                  'balance': remainingBalance,
                  'accountType': cardTypeName,
                  'secondDetail': accountNumber,
                  'thirdDetail': lastTransactionText,
                  'bankName': bankName,
                  'docId': savingsDoc.id,
                  'interestRate': interestRate,
                  'hasInterestRate': interestRate != null,
                });
              }

              setState(() {
                _savings = cards;
                _isLoading = false;
              });
            } catch (e) {
              print('Error processing savings data: $e');
              setState(() {
                _isLoading = false;
              });
            }
          },
          onError: (error) {
            print('Error listening to savings accounts: $error');
            setState(() {
              _isLoading = false;
            });
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AccountsPageAppbar(
        title: 'Savings',
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
            onTap: () async {
              // Wait for result from AddingAccountSavingsPage
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddingAccountSavingsPage(),
                ),
              );

              // If account was added successfully, refresh data
              if (result == true) {
                await _fetchSavingsData(); // Refresh savings data
              }
            },
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
              : _savings.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'No Savings Found',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF044E42),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Tap the + button to add a Savings",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              )
              : RefreshIndicator(
                onRefresh: () => _fetchSavingsData(),
                color: const Color(0xFF06D6A0),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ..._savings.map(
                          (card) => Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: AccountCard(
                              balanceHolder: card['balance'],
                              accountTypeHolder: card['accountType'],
                              secondDetail: formatAccountNumber(
                                card['secondDetail'],
                              ),
                              thirdDetail: card['thirdDetail'],
                              associatedName: card['bankName'],
                              isAccountNumber: true,
                              isHidden: !_eyeEnabled,
                              hasInterestRate: card['hasInterestRate'],
                              interestRate: card['interestRate'],
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => SavingsDetailsPage(
                                          savingsId: card['docId'],
                                        ),
                                  ),
                                );
                                // ----------------------
                                // ScaffoldMessenger.of(context).showSnackBar(
                                //   SnackBar(content: Text(card['docId'])),
                                // );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}
