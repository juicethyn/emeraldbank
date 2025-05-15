import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/styles/accountdetails_appbar.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/widgets/account_balance_overview.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/widgets/account_details_section.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/widgets/account_transaction_button_section.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/widgets/account_virtualcard.dart';
import 'package:emeraldbank_mobileapp/utils/formatting_utils.dart';
import 'package:flutter/material.dart';

class CreditCardDetailsPage extends StatefulWidget {
  final String creditCardId;

  const CreditCardDetailsPage({super.key, required this.creditCardId});

  @override
  State<CreditCardDetailsPage> createState() => _CreditCardDetailsPage();
}

class _CreditCardDetailsPage extends State<CreditCardDetailsPage> {
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
    _setupFireStoreListener();
  }

  void _setupFireStoreListener() {
    _accountSubscription = FirebaseFirestore.instance
        .collection('creditCard')
        .doc(widget.creditCardId)
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
      final accountInfo = await _fetchAccountTypeDetails();

      setState(() {
        _referenceData = {
          'accountHolderName': accountHolderName,
          'bankName': bankInfo['bankName'],
          'shortName': bankInfo['shortName'],
          'accountType': accountInfo['accountType'],
          'interestRate': accountInfo['interestRate'],
          'cutOffDate': accountInfo['cutOffDate'],
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
          'cutOffDate': 'CutOffDate',
        };
      });
    }
  }

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

  Future<Map<String, dynamic>> _fetchBankName() async {
    try {
      final bankRef = _accountData['creditCardInformation']?['associatedBank'];

      if (bankRef == null) {
        return {
          'bankName': 'Unknown Bankname',
          'shortName': 'Unknown Short Bankname',
        };
      }

      if (bankRef is DocumentReference) {
        final bankDoc = await bankRef.get();
        if (bankDoc.exists) {
          final bankData = bankDoc.data() as Map<String, dynamic>?;

          return {
            'bankName': bankData?['bank_name'] ?? 'Unknown Bankname',
            'shortName':
                bankData?['short_name']?.toString() ?? 'Unknown ShortName',
          };
        }
      }
      return {
        'bankName': 'Unknown Bankname',
        'shortName': 'Unknown Short Bankname',
      };
    } catch (e) {
      print('Error fetching bank name: $e');
      return {
        'bankName': 'Unknown Bankname',
        'shortName': 'Unknown Short Bankname',
      };
    }
  }

  Future<Map<String, dynamic>> _fetchAccountTypeDetails() async {
    try {
      final accountTypeRef =
          _accountData['creditCardInformation']?['accountType'];

      if (accountTypeRef == null) {
        return {
          'accountType': 'Unknown Account Type',
          'interestRate': '0.0',
          'cutOffDate': 'Unknown Cutoff',
        };
      }

      if (accountTypeRef is DocumentReference) {
        final accountTypeDoc = await accountTypeRef.get();
        if (accountTypeDoc.exists) {
          final accountTypeData =
              accountTypeDoc.data() as Map<String, dynamic>?;

          return {
            'accountType': accountTypeData?['name'] ?? 'Unknown Type',
            'interestRate':
                accountTypeData?['interestRate']?.toString() ?? '0.0',
            'cutOffDate': accountTypeData?['cutOffDate'] ?? 'Unknown Cutoff',
          };
        }
      }
      return {
        'accountType': 'Unknown Account Type',
        'interestRate': '0.0',
        'cutOffDate': 'Unknown Cutoff',
      };
    } catch (e) {
      print('Error fetching account type data: $e');
      return {
        'accountType': 'Unknown Account Type',
        'interestRate': '0.0',
        'cutOffDate': 'Unknown Cutoff',
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountHolderName =
        _referenceData?['accountHolderName'] ?? 'Account Holder';
    final associatedHolderFullName =
        _referenceData?['bankName'] ?? 'Unknown BankName';
    final associatedHolderShortName =
        _referenceData?['shortName'] ?? 'Unknown Short Bankname';
    final interestRate = formatInterestRateDisplay(
      _referenceData?['interestRate'],
    );
    final accountType = _referenceData?['accountType'] ?? 'Account Type';
    final cutOffDate = _referenceData?['cutOffDate'] ?? 'CutOffDate';
    final accountNumber =
        _accountData['creditCardInformation']?['accountNumber'];
    final cardNumber =
        _accountData['creditCardInformation']?['creditCardNumber'];
    final expiryDate = _accountData['expiryDate'];
    final remainingCredit = toDouble(_accountData['remainingCredit']);
    final creditLimit = toDouble(_accountData['creditLimit']);
    final createdAtTimestamp =
        _accountData['createdAt'] != null
            ? formatDateMMDDYYYY(
              (_accountData['createdAt'] as Timestamp).toDate(),
            )
            : 'N/A';

    final billingDueDate = formatDateToWords(
      _accountData['currentBilling']?['billingDueDate'],
    );
    final minimumPaymentDue = toDouble(
      _accountData['currentBilling']?['minimumDue'],
    );
    final annualFee = toDouble(_accountData['currentBilling']?['AnnualFee']);

    return Scaffold(
      appBar: AccountDetailsAppbar(title: 'Account Details'),
      body:
          _isLoading || _isReferencesLoading
              ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF06D6A0)),
              )
              : RefreshIndicator(
                color: Color(0xFF06D6A0),
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
                            accountHolderName: accountHolderName,
                            cardNumber: cardNumber,
                            accountType: accountType,
                            associatedHolderName: associatedHolderShortName,
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

                        Center(
                          child: AccountBalanceOverview(
                            balance: remainingCredit,
                            maxBalance: creditLimit,
                            balanceTitle: 'Remaining Credit',
                            isHidden: _isBalanceHidden,
                            onVisibilityToggle: () {
                              setState(() {
                                _isBalanceHidden = !_isBalanceHidden;
                              });
                            },
                          ),
                        ),

                        const SizedBox(height: 24),

                        TransactionButtonRow(
                          buttons: [
                            AccountTransactionButtonSection(
                              label: 'Lock Card',
                              iconPath: 'lib/assets/icons/logo_small_icon.svg',
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Lock Card')),
                                );
                              },
                            ),
                            AccountTransactionButtonSection(
                              label: 'Pay Bills',
                              iconPath: 'lib/assets/icons/logo_small_icon.svg',
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Pay Bills Using Credit Card',
                                    ),
                                  ),
                                );
                              },
                            ),
                            AccountTransactionButtonSection(
                              label: 'Pay Credit Bill',
                              iconPath: 'lib/assets/icons/logo_small_icon.svg',
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Pay Credit Bills')),
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
                            'Account Holder': accountHolderName,
                            'Account Number': formatAccountNumber(
                              accountNumber,
                            ),
                            'Card Number': formatAccountNumber(cardNumber),
                            'Account Type': accountType,
                            'Interest': interestRate,
                            'Bank': associatedHolderFullName,
                            'Cut-off Date': cutOffDate,
                            'Billing Due Date': billingDueDate,
                          },
                        ),

                        const SizedBox(height: 24),

                        AccountDetailsSection(
                          sectionTitle: 'Other Details',
                          details: {
                            'Minimum Payment Due': formatCurrency(
                              minimumPaymentDue,
                            ),
                            'Annual Fee': formatCurrency(annualFee),
                            'Account Opening Date': createdAtTimestamp,
                          },
                          eneableToggle: false,
                        ),

                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}
