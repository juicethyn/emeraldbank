import 'package:emeraldbank_mobileapp/features/user_auth/presentation/styles/color_style.dart';
import 'package:emeraldbank_mobileapp/utils/formatting_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AccountBalanceOverview extends StatelessWidget {
  final double balance;
  final double? maxBalance;
  final String? interestRate;
  final String balanceTitle;
  final bool isHidden;
  final VoidCallback onVisibilityToggle;

  const AccountBalanceOverview({
    super.key,
    required this.balance,
    this.maxBalance,
    required this.balanceTitle,
    required this.isHidden,
    this.interestRate,
    required this.onVisibilityToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF06D6A0).withAlpha(51),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF044E42).withAlpha(64),
            blurRadius: 4,
            offset: const Offset(0, 0),
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            balanceTitle,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: Color(0xFF044E42),
            ),
          ),

          const SizedBox(height: 4),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Balance with optional max balance
              Row(
                children: [
                  Row(
                    children: [
                      Text(
                        isHidden ? '₱ ××××.××' : formatCurrency(balance),
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),

                      // Show max balance if provided
                      if (maxBalance != null) ...[
                        const SizedBox(width: 4),
                        Text(
                          isHidden
                              ? '/ ₱ ××××.××'
                              : '/ ${formatCurrency(maxBalance!).trim()}',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.black.withAlpha(102),
                          ),
                        ),
                      ],
                    ],
                  ),

                  if (interestRate != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FFE5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'lib/assets/icons/chart_line.svg',
                            width: 12,
                            height: 12,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFF044E42),
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            interestRate!,
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: Color(0xFF044E42),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),

              InkWell(
                onTap: onVisibilityToggle,
                borderRadius: BorderRadius.circular(100),

                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    gradient: Customgradients.iconGradient,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isHidden ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
