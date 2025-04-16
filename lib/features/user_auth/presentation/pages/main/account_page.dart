import 'package:emeraldbank_mobileapp/features/user_auth/presentation/pages/main/creditCard/creditcard_page.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/pages/main/loans/loans_page.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/pages/savings/savings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

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
                const Center(
                  child: Text(
                    'Accounts',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
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
                      accountCount: 2,
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
                      accountCount: 2,
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
                      accountCount: 2,
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
    int accountCount = 2,
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
                      opacity: 0.5,
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
                            child: Text(
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
