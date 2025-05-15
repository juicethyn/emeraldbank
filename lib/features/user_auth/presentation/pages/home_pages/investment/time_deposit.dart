import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/pages/home_pages/investment/time_deposit_receipt.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

class TimeDeposit extends StatefulWidget {
  const TimeDeposit({super.key});

  @override
  State<TimeDeposit> createState() => _TimeDepositState();
}

class _TimeDepositState extends State<TimeDeposit> {
  String? _selectedSourceAccount;
  String? _selectedTermLength;
  String? _selectedInterestPayout = 'At Maturity';
  List<Map<String, dynamic>> _firebaseSourceAccounts = [];
  bool _isLoadingAccounts = true;
  double? _selectedAccountBalance;
  final TextEditingController _depositAmountController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<String> _termLengths = [
    '3 Months',
    '6 Months',
    '1 Year',
    '2 Years',
  ];
  final List<String> _interestPayouts = [
    'At Maturity',
    'Monthly',
    'Quarterly',
    'Semi-Annually',
    'Annually',
  ];

  @override
  void initState() {
    super.initState();
    _loadSourceAccounts();
    _depositAmountController.addListener(() {
      setState(() {}); // To update interest preview as user types
    });
  }

  @override
  void dispose() {
    _depositAmountController.dispose();
    super.dispose();
  }

  Future<void> _loadSourceAccounts() async {
    final ids = await fetchUserSavingsAccountIds();
    List<Map<String, dynamic>> accounts = [];
    for (final id in ids) {
      final account = await fetchUserSavingsAccount(id);
      if (account != null) {
        account['id'] = id;
        accounts.add(account);
      }
    }
    setState(() {
      _firebaseSourceAccounts = accounts;
      _isLoadingAccounts = false;
    });
  }

  void _onSourceAccountSelected(String? selected) async {
    setState(() {
      _selectedSourceAccount = selected;
      _selectedAccountBalance = null;
    });
    if (selected != null) {
      final account = await fetchUserSavingsAccount(selected);
      if (account != null) {
        setState(() {
          _selectedAccountBalance = (account['currentBalance'] as num?)?.toDouble();
        });
      }
    }
  }

  bool get _isDepositAmountInvalid {
    final depositAmount = double.tryParse(_depositAmountController.text.replaceAll(',', '')) ?? 0.0;
    return _selectedAccountBalance != null && depositAmount > _selectedAccountBalance!;
  }

  String _monthName(int month) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'June',
      'July', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec'
    ];
    return months[month];
  }

  @override
  Widget build(BuildContext context) {
    // Date and Interest Calculation
    final DateTime today = DateTime.now();
    DateTime maturityDate = today;
    if (_selectedTermLength != null) {
      switch (_selectedTermLength) {
        case '3 Months':
          maturityDate = DateTime(today.year, today.month + 3, today.day);
          break;
        case '6 Months':
          maturityDate = DateTime(today.year, today.month + 6, today.day);
          break;
        case '1 Year':
          maturityDate = DateTime(today.year + 1, today.month, today.day);
          break;
        case '2 Years':
          maturityDate = DateTime(today.year + 2, today.month, today.day);
          break;
      }
    }
    final String formattedMaturity = "${maturityDate.day} ${_monthName(maturityDate.month)}, ${maturityDate.year}";

    double interestRate = 0.065; // 6.5%
    double depositAmount = double.tryParse(_depositAmountController.text.replaceAll(',', '')) ?? 0.0;
    double interest = 0.0;
    if (_selectedTermLength != null && depositAmount > 0) {
      int months = 0;
      switch (_selectedTermLength) {
        case '3 Months':
          months = 3;
          break;
        case '6 Months':
          months = 6;
          break;
        case '1 Year':
          months = 12;
          break;
        case '2 Years':
          months = 24;
          break;
      }
      interest = depositAmount * interestRate * (months / 12);
    }

    // For displaying "Savings #n"
    int selectedIndex = _firebaseSourceAccounts.indexWhere((acc) => acc['id'] == _selectedSourceAccount);
    String selectedAccountLabel = selectedIndex != -1 ? 'Savings #${selectedIndex + 1}' : '';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Time Deposit",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Setup your Time Deposit",
                        style: TextStyle(
                          fontSize: 24,
                          color: Color(0xFF06D6A0),
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Secure your savings and grow your wealth by setting up your time deposit.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24,),
                Row(
                  children: [
                    Text(
                      "Select Source Account",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _isLoadingAccounts
                  ? Center(child: CircularProgressIndicator())
                  : DropdownButtonFormField2<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      hint: const Text(
                        'Choose Source Account',
                        style: TextStyle(color: Colors.black54, fontSize: 14),
                      ),
                      items: _firebaseSourceAccounts.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final account = entry.value;
                        return DropdownMenuItem<String>(
                          value: account['id'],
                          child: Text(
                            'Savings #${idx + 1}',
                            style: const TextStyle(color: Colors.black87, fontSize: 16),
                          ),
                        );
                      }).toList(),
                      value: _selectedSourceAccount,
                      onChanged: (String? newValue) {
                        _onSourceAccountSelected(newValue);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a source account';
                        }
                        return null;
                      },
                    ),
                if (_selectedAccountBalance != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Row(
                      children: [
                        Text(
                          "Available Balance: ",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "₱${_selectedAccountBalance!.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF06D6A0),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      "Deposit Amount to Invest",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _depositAmountController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    hintText: 'Php 0.00',
                    hintStyle: TextStyle(color: Colors.black54, fontSize: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: _isDepositAmountInvalid ? Colors.red : Colors.grey,
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: _isDepositAmountInvalid ? Colors.red : Colors.grey,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: _isDepositAmountInvalid ? Colors.red : Color(0xFF06D6A0),
                        width: 2,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    errorText: _isDepositAmountInvalid
                        ? 'Amount exceeds available balance'
                        : null,
                  ),
                  style: TextStyle(color: Colors.black87, fontSize: 16),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    if (_isDepositAmountInvalid) {
                      return 'Amount exceeds available balance';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      "Select Term Length",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField2<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  hint: const Text(
                    'Choose Term Length',
                    style: TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                  items: _termLengths.map((String term) {
                    return DropdownMenuItem<String>(
                      value: term,
                      child: Text(
                        term,
                        style: const TextStyle(color: Colors.black87, fontSize: 16),
                      ),
                    );
                  }).toList(),
                  value: _selectedTermLength,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedTermLength = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a term length';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      "Interest Payout",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField2<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  hint: const Text(
                    'Choose a Interest Payout',
                    style: TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                  items: _interestPayouts.map((String term) {
                    return DropdownMenuItem<String>(
                      value: term,
                      child: Text(
                        term,
                        style: const TextStyle(color: Colors.black87, fontSize: 16),
                      ),
                    );
                  }).toList(),
                  value: _selectedInterestPayout,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedInterestPayout = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a interest payout';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      "Summary Preview",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  height: 88,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Interest at Maturity",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              "₱${interest.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF06D6A0),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Maturity Date",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              formattedMaturity,
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF06D6A0),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Interest Rate",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              "6.50%",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF06D6A0),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () {
                    // Validate all fields before showing the review dialog
                    if (!_formKey.currentState!.validate()) {
                      // If not valid, do not proceed
                      return;
                    }
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          title: const Text(
                            'Time Deposit Review',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          content: SizedBox(
                            width: double.infinity,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Pay From:',
                                      style: TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      selectedAccountLabel,
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Deposit Amount:',
                                      style: TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      'Php ${depositAmount.toStringAsFixed(2)}',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Interest Rate:',
                                      style: TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      '6.50%',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Term:',
                                      style: TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      _selectedTermLength ?? '',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Maturity Amount:',
                                      style: TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      'Php ${(depositAmount + interest).toStringAsFixed(2)}',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Maturity Interest:',
                                      style: TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      'Php ${interest.toStringAsFixed(2)}',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Interest Payout:',
                                      style: TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      _selectedInterestPayout ?? '',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Maturity Date:',
                                      style: TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      formattedMaturity,
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Payout Account:',
                                      style: TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      selectedAccountLabel,
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                          actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          actions: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Color(0xFF06D6A0),
                                      side: BorderSide(color: Color(0xFF06D6A0)),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                    ),
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text('Cancel'),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF06D6A0),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                      elevation: 0,
                                    ),
                                    onPressed: () async {
                                      if (_isDepositAmountInvalid || depositAmount <= 0 || _selectedSourceAccount == null) return;

                                      // Show loading dialog
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) => Dialog(
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(24.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                CircularProgressIndicator(color: Color(0xFF06D6A0)),
                                                SizedBox(width: 16),
                                                Text("Processing...", style: TextStyle(fontSize: 16)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );

                                      final newBalance = (_selectedAccountBalance ?? 0) - depositAmount;
                                      final referenceNumber = generateReferenceNumber();

                                      await _processTimeDeposit(
                                        savingsId: _selectedSourceAccount!,
                                        depositAmount: depositAmount,
                                        newBalance: newBalance,
                                        referenceNumber: referenceNumber,
                                        selectedAccountLabel: selectedAccountLabel,
                                        interest: interest,
                                        selectedTermLength: _selectedTermLength ?? '',
                                        selectedInterestPayout: _selectedInterestPayout ?? '',
                                        formattedMaturity: formattedMaturity,
                                      );

                                      Navigator.of(context).pop(); // Close loading dialog
                                      Navigator.of(context).pop(); // Close review dialog

                                      Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TimeDepositReceipt(
                                          referenceNumber: referenceNumber,
                                          payFrom: selectedAccountLabel,
                                          depositAmount: depositAmount,
                                          interestRate: 0.065,
                                          term: _selectedTermLength ?? '',
                                          maturityAmount: depositAmount + interest,
                                          maturityInterest: interest,
                                          interestPayout: _selectedInterestPayout ?? '',
                                          maturityDate: formattedMaturity,
                                          transactionDate: "${DateTime.now().day} ${_monthName(DateTime.now().month)}, ${DateTime.now().year}",
                                        ),
                                      ),
                                    );
                                    },
                                    child: const Text('Confirm'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Color(0xFF06D6A0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Continue",
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
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

Future<List<String>> fetchUserSavingsAccountIds() async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return [];

  final refSnap = await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('accountReferences')
      .get();

  List<String> savingsAccountIds = [];
  for (var doc in refSnap.docs) {
    final List<dynamic>? ids = doc.data()['savingsAccounts'];
    if (ids != null) {
      savingsAccountIds.addAll(ids.map((id) {
        if (id is String && id.contains('/')) {
          return id.split('/').last;
        }
        return id;
      }).cast<String>());
    }
  }
  return savingsAccountIds;
}

Future<Map<String, dynamic>?> fetchUserSavingsAccount(String savingsId) async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return null;

  final doc = await FirebaseFirestore.instance
      .collection('savings')
      .doc(savingsId)
      .get();

  if (doc.exists && doc.data()?['accountHolder'] == 'users/$uid') {
    return doc.data();
  }
  return null;
}

Future<void> _processTimeDeposit({
  required String savingsId,
  required double depositAmount,
  required double newBalance,
  required String referenceNumber,
  required String selectedAccountLabel,
  required double interest,
  required String selectedTermLength,
  required String selectedInterestPayout,
  required String formattedMaturity,
}) async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return;

  final userDoc = FirebaseFirestore.instance.collection('users').doc(uid);

  // 1. Update savings account balance
  await FirebaseFirestore.instance
      .collection('savings')
      .doc(savingsId)
      .update({'currentBalance': newBalance});

  // 2. Add Time Deposit record to user's collection
  await userDoc.collection('timeDeposit').doc(referenceNumber).set({
    'referenceNumber': referenceNumber,
    'payFrom': selectedAccountLabel,
    'depositAmount': depositAmount,
    'interestRate': 0.065,
    'term': selectedTermLength,
    'maturityAmount': depositAmount + interest,
    'maturityInterest': interest,
    'interestPayout': selectedInterestPayout,
    'maturityDate': formattedMaturity,
    'createdAt': FieldValue.serverTimestamp(),
  });
}

// Helper to generate a random reference number
String generateReferenceNumber() {
  final now = DateTime.now();
  final rand = Random();
  return 'REF${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${rand.nextInt(999999).toString().padLeft(6, '0')}';
}
