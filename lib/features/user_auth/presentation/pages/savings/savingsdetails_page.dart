import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/styles/accountdetails_appbar.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/widgets/account_balance_overview.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/widgets/account_virtualCard.dart';
import 'package:flutter/material.dart';

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
      final bankName = await _fetchBankName();
      final accountInfo = await _fetchAccountTypeAndInterest();

      setState(() {
        _referenceData = {
          'accountHolderName': accountHolderName,
          'bankName': bankName,
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
            'Account Holder';
      }

      return 'Account Holder';
    } catch (e) {
      print('Error fetching account holder name: $e');
      return 'Account Holder';
    }
  }

  // Fetch bank name
  Future<String> _fetchBankName() async {
    try {
      final bankRef =
          _accountData['savingsAccountInformation']?['associatedBank'];
      if (bankRef == null) return 'Unknown Bank';

      if (bankRef is DocumentReference) {
        final bankDoc = await bankRef.get();
        if (bankDoc.exists) {
          final bankData = bankDoc.data() as Map<String, dynamic>?;
          return bankData?['short_name'] ?? bankData?['name'] ?? 'EmeraldBank';
        }
      }
      return 'Unknown Bank';
    } catch (e) {
      print('Error fetching bank name: $e');
      return 'EmeraldBank';
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

  double getFormattedInterestRate() {
    final rawRate = double.tryParse(_referenceData?['interestRate'] ?? '0');
    if (rawRate == null) return 0.0;

    // Convert from decimal to percentage
    return rawRate * 100;
  }

  @override
  Widget build(BuildContext context) {
    // Extract account data fields that we already have
    final accountNumber =
        _accountData['savingsAccountInformation']?['accountNumber'];
    final cardNumber = _accountData['savingsAccountInformation']?['cardNumber'];
    final expiryDate = _accountData['expiryDate'];
    final remainingBalance = (_accountData['currentBalance'] ?? 0.0).toDouble();

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
                            accountHolderName:
                                _referenceData!['accountHolderName'] ??
                                'Account Holder',
                            associatedHolderName:
                                _referenceData!['bankName'] ?? 'Bank Name',
                            accountType:
                                _referenceData!['accountType'] ??
                                'Account Type',
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
                            interestRate: getFormattedInterestRate(),
                            balanceTitle: 'Balance',
                            isHidden: _isBalanceHidden,
                            onVisibilityToggle: () {
                              setState(() {
                                _isBalanceHidden = !_isBalanceHidden;
                              });
                            },
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
