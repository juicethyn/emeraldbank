import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/pages/main/creditCard/creditcard_page.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/pages/main/loans/loans_page.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/pages/savings/savings_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageSatate();
}

class _AccountPageSatate extends State<AccountPage> {
  int _savingsCount = 0;
  int _creditCardCount = 0;
  int _loanCount = 0;
  bool _isLoading = true;

  StreamSubscription<QuerySnapshot>? _accountStreamSubscription;

  @override
  void initState() {
    super.initState();
    _setupAccountCountsListener();
  }

  @override
  void dispose() {
    _accountStreamSubscription?.cancel();
    super.dispose();
  }

  void _setupAccountCountsListener() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Create stream instead of one-time fetch
    _accountStreamSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('accountReferences')
        .limit(1)
        .snapshots() // Use snapshots() instead of get()
        .listen(
          (snapshot) {
            if (snapshot.docs.isNotEmpty) {
              final accountRefsDoc = snapshot.docs.first;
              final data = accountRefsDoc.data();

              // Get account count from arrays
              final savingsAccount = data['savingsAccounts'] as List?;
              final creditCardAccounts = data['creditCardAccounts'] as List?;
              final loanAccounts = data['loanAccounts'] as List?;

              setState(() {
                _savingsCount =
                    savingsAccount?.where((item) => item != null).length ?? 0;
                _creditCardCount =
                    creditCardAccounts?.where((item) => item != null).length ??
                    0;
                _loanCount =
                    loanAccounts?.where((item) => item != null).length ?? 0;
                _isLoading = false;
              });
            } else {
              setState(() {
                _isLoading = false;
              });
            }
          },
          onError: (error) {
            print('Error listening to account counts: $error');
            setState(() {
              _isLoading = false;
            });
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // added
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Accounts',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_isLoading) ...[
                      const SizedBox(width: 10),
                      const SizedBox(
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFF06D6A0),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 16),

                // const Center(
                //   child: Text(
                //     'Accounts',
                //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                //   ),
                // ),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  childAspectRatio: 1,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildServiceCard(
                      context,
                      'Savings',
                      'lib/assets/icons/piggybank_cardIcon.svg',
                      const Color(0xFF06D6A0),
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SavingsPage(),
                        ),
                      ),
                      accountCount: _savingsCount,
                    ),
                    _buildServiceCard(
                      context,
                      'Credit Cards',
                      'lib/assets/icons/creditcard_cardIcon.svg',
                      const Color(0xFF06D6A0),
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreditcardPage(),
                        ),
                      ),
                      accountCount: _creditCardCount,
                    ),
                    _buildServiceCard(
                      context,
                      'Loans',
                      'lib/assets/icons/loans_cardIcon.svg',
                      const Color(0xFF06D6A0),
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoansPage(),
                        ),
                      ),
                      accountCount: _loanCount,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context,
    String title,
    dynamic icon,
    Color color,
    VoidCallback onTap, {
    int accountCount = 0,
  }) {
    return Container(
      width: 160.5,
      height: 160,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF044E42).withAlpha(102),
            blurRadius: 20,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // Icon with Opacity
              Positioned(
                right: 4,
                bottom: 4,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final containerWidth = 160;
                    final iconSize = containerWidth * 0.7;
                    final finalSize = iconSize > 128 ? iconSize : 128.0;

                    return Opacity(
                      opacity: 1.0,
                      child:
                          icon is IconData
                              ? Icon(
                                icon,
                                size: finalSize,
                                color: Colors.black.withAlpha(51),
                              )
                              : SvgPicture.asset(
                                icon.toString(),
                                width: finalSize,
                                height: finalSize,
                              ),
                    );
                  },
                ),
              ),

              // Category Frame (pill shape)
              Positioned(
                left: 0,
                right: 24,
                top: 24,
                child: Container(
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(102),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Row(
                      children: [
                        // Counter Circle
                        Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: Color(0xFF044E42),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child:
                                _isLoading
                                    ? const SizedBox(
                                      width: 12,
                                      height: 12,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Color(0xFFF8F9FA),
                                      ),
                                    )
                                    : Text(
                                      accountCount.toString(),
                                      style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Color(0xFFF8F9FA),
                                      ),
                                    ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        // Account Type Label
                        Text(
                          title,
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF1A1819),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    // return Container(
    //   width: 160.5,
    //   height: 160,
    //   decoration: BoxDecoration(
    //     color: color,
    //     borderRadius: BorderRadius.circular(24),
    //     boxShadow: [
    //       BoxShadow(
    //         color: Colors.black.withAlpha(51),
    //         blurRadius: 10,
    //         offset: const Offset(0, 4),
    //       ),
    //     ],
    //   ),
    //   child: Material(
    //     color: Colors.transparent,
    //     child: InkWell(
    //       onTap: onTap,
    //       borderRadius: BorderRadius.circular(24),
    //       child: Padding(
    //         padding: const EdgeInsets.all(16.0),
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             Icon(icon, size: 32),
    //             const SizedBox(height: 8),
    //             Text(
    //               title,
    //               style: const TextStyle(
    //                 fontSize: 16,
    //                 fontWeight: FontWeight.bold,
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
    // return Card(
    //   elevation: 4,
    //   color: color,
    //   child: InkWell(
    //     onTap: onTap,
    //     child: Padding(
    //       padding: const EdgeInsets.all(16.0),
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           Icon(icon, size: 32),
    //           const SizedBox(height: 8),
    //           Text(
    //             title,
    //             style: const TextStyle(
    //               fontSize: 16,
    //               fontWeight: FontWeight.bold,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
