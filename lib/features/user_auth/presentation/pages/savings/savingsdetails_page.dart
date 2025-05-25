import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/pages/main/transactionPage/transaction_details.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/pages/main/transactionPage/transactionhistory_page.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/styles/accountdetails_appbar.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/widgets/account_balance_overview.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/widgets/account_details_section.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/widgets/account_transaction_button_section.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/widgets/account_virtualCard.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/widgets/transaction_overview.dart';
import 'package:emeraldbank_mobileapp/utils/formatting_utils.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class SavingsDetailsPage extends StatefulWidget {
  final String savingsId;

  const SavingsDetailsPage({super.key, required this.savingsId});

  @override
  State<SavingsDetailsPage> createState() => _SavingsDetailsPageState();
}

class _SavingsDetailsPageState extends State<SavingsDetailsPage> {
  bool _isLoading = true;
  bool _isHidden = false;
  bool _isBalanceHidden = false;
  Map<String, dynamic> _accountData = {};
  Map<String, String>? _referenceData;
  bool _isReferencesLoading = true;
  StreamSubscription<DocumentSnapshot>? _accountSubscription;

  @override
  void initState() {
    super.initState();
    _setupFirestoreListener();
  }

  void _setupFirestoreListener() {
    _accountSubscription = FirebaseFirestore.instance
        .collection('savings')
        .doc(widget.savingsId)
        .snapshots()
        .listen(
          (docSnapshot) {
            if (docSnapshot.exists) {
              setState(() {
                _accountData = docSnapshot.data() ?? {};
                _isLoading = false;
              });

              _loadReferenceData();
            } else {
              setState(() {
                _isLoading = false;
              });
            }
          },
          onError: (e) {
            print('Error listening to account changes: $e');
            setState(() {
              _isLoading = false;
            });
          },
        );
  }

  @override
  void dispose() {
    _accountSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadReferenceData() async {
    try {
      final accountHolderName = await _fetchAccountHolderName();
      final bankInfo = await _fetchBankName();
      final accountInfo = await _fetchAccountTypeAndInterest();

      setState(() {
        _referenceData = {
          'accountHolderName': accountHolderName,
          'bankName': bankInfo['bankName'],
          'shortName': bankInfo['shortName'],
          'accountType': accountInfo['accountType'],
          'interestRate': accountInfo['interestRate'],
        };
        _isReferencesLoading = false;
      });
    } catch (e) {
      print('Error loading reference data: $e');
      setState(() {
        _isReferencesLoading = false;
        _referenceData = {
          'accountHolderName': 'Account Holder',
          'bankName': 'Bank Name',
          'accountType': 'Account Type',
          'interestRate': '0.0',
        };
      });
    }
  }

  // Fetch account Holder name
  Future<String> _fetchAccountHolderName() async {
    try {
      final accountHolderRef = _accountData['accountHolder'];

      if (accountHolderRef == null) {
        return 'Account Holder';
      }

      DocumentSnapshot userDoc;
      if (accountHolderRef is DocumentReference) {
        userDoc = await accountHolderRef.get();
      } else {
        final String refPath = accountHolderRef.toString();
        userDoc = await FirebaseFirestore.instance.doc(refPath).get();
      }

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>?;
        return userData?['accountName'] ??
            userData?['accountNickname'] ??
            userData?['name'] ??
            userData?['fullName'] ??
            'Account Holder';
      }

      return 'Account Holder';
    } catch (e) {
      print('Error fetching account holder name: $e');
      return 'Account Holder';
    }
  }

  // Fetch bank name and short name
  Future<Map<String, dynamic>> _fetchBankName() async {
    try {
      final bankRef =
          _accountData['savingsAccountInformation']?['associatedBank'];
      if (bankRef == null) {
        return {
          'bankName': 'Unkown Bankname',
          'shortName': 'Unkown Short Bankname',
        };
      }

      if (bankRef is DocumentReference) {
        final bankDoc = await bankRef.get();
        if (bankDoc.exists) {
          final bankData = bankDoc.data() as Map<String, dynamic>?;

          return {
            'bankName': bankData?['bank_name'] ?? 'Unknown Bankname',
            'shortName': bankData?['short_name']?.toString() ?? '0.0',
          };
        }
      }
      return {
        'bankName': 'Unkown Bankname',
        'shortName': 'Unkown Short Bankname',
      };
    } catch (e) {
      print('Error fetching bank name: $e');
      return {
        'bankName': 'Unkown Bankname',
        'shortName': 'Unkown Short Bankname',
      };
    }
  }

  // Fetch Account Type and InterestRate
  Future<Map<String, dynamic>> _fetchAccountTypeAndInterest() async {
    try {
      final accountTypeRef =
          _accountData['savingsAccountInformation']?['accountType'];
      if (accountTypeRef == null) {
        return {'accountType': 'Unknown Account Type', 'interestRate': '0.0'};
      }

      if (accountTypeRef is DocumentReference) {
        final accountTypeDoc = await accountTypeRef.get();
        if (accountTypeDoc.exists) {
          final accountTypeData =
              accountTypeDoc.data() as Map<String, dynamic>?;

          // Get both values from the same document
          return {
            'accountType': accountTypeData?['name'] ?? 'Unknown Type',
            'interestRate':
                accountTypeData?['interestRate']?.toString() ?? '0.0',
          };
        }
      }
      return {'accountType': 'Unknown Account Type', 'interestRate': '0.0'};
    } catch (e) {
      print('Error fetching account type data: $e');
      return {'accountType': 'Unknown Account Type', 'interestRate': '0.0'};
    }
  }

  Stream<List<Map<String, dynamic>>> _getTransactionsStream(String accountId) {
    final accountRef = FirebaseFirestore.instance.doc('savings/$accountId');

    // Create individual streams but don't process them yet
    final sourceStream =
        FirebaseFirestore.instance
            .collection('transactions')
            .where('source.sourceRef', isEqualTo: accountRef)
            .orderBy('transactionDate', descending: true)
            .limit(4)
            .snapshots();

    final destStream =
        FirebaseFirestore.instance
            .collection('transactions')
            .where('destination.destinationRef', isEqualTo: accountRef)
            .orderBy('transactionDate', descending: true)
            .limit(4)
            .snapshots();

    // Combine the snapshots, then process them together
    return Rx.combineLatest2(sourceStream, destStream, (
      QuerySnapshot sourceSnapshot,
      QuerySnapshot destSnapshot,
    ) {
      print(
        'DEBUG: Got ${sourceSnapshot.docs.length} source transactions and ${destSnapshot.docs.length} dest transactions',
      );

      // Process source transactions
      final sourceTxs =
          sourceSnapshot.docs
              .map(
                (doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>},
              )
              .toList();

      // Process destination transactions
      final destTxs =
          destSnapshot.docs
              .map(
                (doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>},
              )
              .toList();

      // Combine both lists
      final allTransactions = [...sourceTxs, ...destTxs];

      // Sort by date (newest first)
      allTransactions.sort((a, b) {
        final aDate = (a['transactionDate'] as Timestamp).toDate();
        final bDate = (b['transactionDate'] as Timestamp).toDate();
        return bDate.compareTo(aDate);
      });

      // Remove duplicates based on transaction id
      final uniqueTransactions = <String, Map<String, dynamic>>{};
      for (final tx in allTransactions) {
        uniqueTransactions[tx['id']] = tx;
      }

      final result = uniqueTransactions.values.take(4).toList();
      print('DEBUG: Returning ${result.length} combined transactions');
      return result;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Extract account data fields that we already have
    final accountHoldername =
        _referenceData?['accountHolderName'] ?? 'Account Holder';
    final associatedHolderFullName =
        _referenceData?['bankName'] ?? 'Unknown Bankname';
    final associatedHolderShortName =
        _referenceData?['shortName'] ?? 'Unknown Short Bankname';
    final interestRate = formatInterestRateDisplay(
      _referenceData?['interestRate'],
    );
    final accountType = _referenceData?['accountType'] ?? 'Account Type';
    final accountNumber =
        _accountData['savingsAccountInformation']?['accountNumber'];
    final cardNumber = _accountData['savingsAccountInformation']?['cardNumber'];
    final expiryDate = _accountData['expiryDate'];
    final remainingBalance = toDouble(_accountData['currentBalance']);
    final monthlyWithdrawals = toDouble(
      _accountData['monthlyActivity']?['monthlyWithdrawals'],
    );
    final monthlyDeposit = toDouble(
      _accountData['monthlyActivity']?['monthlyDeposit'],
    );
    final createdAtTimestamp =
        _accountData['createdAt'] != null
            ? formatDateMMDDYYYY(
              (_accountData['createdAt'] as Timestamp).toDate(),
            )
            : 'N/A';

    return Scaffold(
      appBar: AccountDetailsAppbar(title: 'Account Details'),
      body:
          _isLoading || _isReferencesLoading
              ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF06D6A0)),
              )
              : RefreshIndicator(
                color: const Color(0xFF06D6A0),
                onRefresh: () async {
                  setState(() {
                    _isReferencesLoading = true;
                  });
                  await _loadReferenceData();
                  return Future.value();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: VirtualCardWidget(
                            accountNumber: accountNumber,
                            cardNumber: cardNumber,
                            accountHolderName: accountHoldername,
                            associatedHolderName: associatedHolderShortName,
                            accountType: accountType,
                            expiryDate: expiryDate,
                            isHidden: _isHidden,
                            onVisibilityToggle: () {
                              setState(() {
                                _isHidden = !_isHidden;
                              });
                            },
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Account Balance Overview
                        Center(
                          child: AccountBalanceOverview(
                            balance: remainingBalance,
                            interestRate: interestRate,
                            balanceTitle: 'Balance',
                            isHidden: _isBalanceHidden,
                            onVisibilityToggle: () {
                              setState(() {
                                _isBalanceHidden = !_isBalanceHidden;
                              });
                            },
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Transaction Buttons
                        TransactionButtonRow(
                          buttons: [
                            AccountTransactionButtonSection(
                              label: 'Pay Bills',
                              iconPath: 'lib/assets/icons/logo_small_icon.svg',
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Paybills')),
                                );
                              },
                            ),
                            AccountTransactionButtonSection(
                              label: 'Transfer',
                              iconPath: 'lib/assets/icons/logo_small_icon.svg',
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Transfer')),
                                );
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Account Details
                        AccountDetailsSection(
                          sectionTitle: 'Details',
                          details: {
                            'Account Holder':
                                _referenceData!['accountHolderName'] ??
                                'Account Holder',
                            'Account Number': formatAccountNumber(
                              accountNumber,
                            ),
                            'Card Number': formatAccountNumber(cardNumber),
                            'Account Type': accountType,
                            'Interest': interestRate,
                            'Bank': associatedHolderFullName,
                          },
                        ),

                        const SizedBox(height: 24),

                        AccountDetailsSection(
                          sectionTitle: 'Other Details',
                          details: {
                            'Total Monthly Deposit': formatCurrency(
                              monthlyDeposit,
                            ),
                            'Total Monthly Withdrawals': formatCurrency(
                              monthlyWithdrawals,
                            ),
                            'Account Opening Date': createdAtTimestamp,
                          },
                          eneableToggle: false,
                        ),

                        const SizedBox(height: 24),

                        StreamBuilder<List<Map<String, dynamic>>>(
                          stream: _getTransactionsStream(widget.savingsId),
                          builder: (context, snapshot) {
                            // Changed condition to show loading only when actively waiting
                            if (snapshot.connectionState ==
                                    ConnectionState.waiting &&
                                snapshot.data == null) {
                              return const TransactionOverview(
                                transactions: [],
                                isLoading: true,
                              );
                            }

                            if (snapshot.hasError) {
                              return Text(
                                'Error loading transactions: ${snapshot.error}',
                              );
                            }

                            final transactions = snapshot.data ?? [];
                            return TransactionOverview(
                              transactions: transactions,
                              isLoading: false,
                              accountId: widget.savingsId,
                              onViewAllPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => TransactionHistoryPage(
                                          accountId: widget.savingsId,
                                        ),
                                  ),
                                );
                              },
                              onTransactionTap: (transaction) {
                                // Navigate to transaction details
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => TransactionDetails(
                                          transactionId: transaction['id'],
                                          transactionData: transaction,
                                        ),
                                  ),
                                );
                              },
                            );
                          },
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}
