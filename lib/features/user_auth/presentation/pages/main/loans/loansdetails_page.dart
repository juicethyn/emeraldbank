import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/styles/accountdetails_appbar.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/widgets/account_balance_overview.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/widgets/account_details_section.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/widgets/account_transaction_button_section.dart';
import 'package:emeraldbank_mobileapp/utils/formatting_utils.dart';
import 'package:flutter/material.dart';

class LoansdetailsPage extends StatefulWidget {
  final String loanId;

  const LoansdetailsPage({super.key, required this.loanId});

  @override
  State<LoansdetailsPage> createState() => _LoansdetailsPage();
}

class _LoansdetailsPage extends State<LoansdetailsPage> {
  bool _isLoading = true;
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
        .collection('loans')
        .doc(widget.loanId)
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
          'billingType': accountInfo['billingType'],
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
          'billingType': 'billingType',
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
      final bankRef = _accountData['loanAccountInformation']?['associatedBank'];

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
                bankData?['short_name']?.toString() ?? 'Unknown Short BankName',
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
          _accountData['loanAccountInformation']?['accountType'];

      if (accountTypeRef == null) {
        return {
          'accountType': 'Unknown Account Type',
          'interestRate': '0.0',
          'billingType': 'Unknown Billing Type',
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
            'billingType':
                accountTypeData?['billingType'] ?? 'Unknown Billing Type',
          };
        }
      }

      return {
        'accountType': 'Unknown Account Type',
        'interestRate': '0.0',
        'billingType': 'Unknown Billing Type',
      };
    } catch (e) {
      print('Error fetching account type data: $e');
      return {
        'accountType': 'Unknown Account Type',
        'interestRate': '0.0',
        'billingType': 'Unknown Billing Type',
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
    final billingType = _referenceData?['billingType'] ?? 'Account Type';
    final accountNumber =
        _accountData['loanAccountInformation']?['accountNumber'];
    final remainingBalance = toDouble(_accountData['loanBalance']);
    final totalLoanAmount = toDouble(_accountData['totalLoan']);
    final createdAtTimestamp =
        _accountData['createdAt'] != null
            ? formatDateMMDDYYYY(
              (_accountData['createdAt'] as Timestamp).toDate(),
            )
            : 'N/A';

    final billingDueDate = formatDateToWords(
      _accountData['currentBilling']?['billingDueDate'],
    );
    final billingDue = toDouble(_accountData['currentBilling']?['billingDue']);

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
                          child: Center(
                            child: AccountBalanceOverview(
                              balance: remainingBalance,
                              maxBalance: totalLoanAmount,
                              balanceTitle: 'Remaining Loan',
                              isHidden: _isBalanceHidden,
                              onVisibilityToggle: () {
                                setState(() {
                                  _isBalanceHidden = !_isBalanceHidden;
                                });
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        TransactionButtonRow(
                          buttons: [
                            AccountTransactionButtonSection(
                              label: 'Pay Loan',
                              iconPath: 'lib/assets/icons/logo_small_icon.svg',
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Pay Loan')),
                                );
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        AccountDetailsSection(
                          sectionTitle: 'Details',
                          details: {
                            'Account Holder': accountHolderName,
                            'Account Number': formatAccountNumber(
                              accountNumber,
                            ),
                            'Account Type': accountType,
                            'Interest': interestRate,
                            'Bank':
                                '$associatedHolderFullName ($associatedHolderShortName)',
                          },
                        ),

                        const SizedBox(height: 24),

                        AccountDetailsSection(
                          sectionTitle: 'Other Details',
                          details: {
                            'Billing Type': billingType,
                            'Start Date': formatDateToWords(createdAtTimestamp),
                            'Billing Due': formatCurrency(billingDue),
                            'Billing Due Date': formatDateToWords(
                              billingDueDate,
                            ),
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
