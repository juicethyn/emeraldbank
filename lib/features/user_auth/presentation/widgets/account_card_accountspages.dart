import 'package:emeraldbank_mobileapp/features/user_auth/presentation/styles/color_style.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AccountCard extends StatelessWidget {
  final double balanceHolder;
  final double? limitBalanceHolder;
  final String accountTypeHolder;
  final String secondDetail;
  final String thirdDetail;
  final String associatedName;
  final bool isHidden;
  final String? logoAsset;
  final bool? isAccountNumber;
  final VoidCallback onTap;

  const AccountCard({
    super.key,
    required this.balanceHolder,
    this.limitBalanceHolder,
    required this.accountTypeHolder,
    required this.secondDetail,
    required this.thirdDetail,
    required this.associatedName,
    required this.isHidden,
    this.logoAsset,
    required this.onTap,
    this.isAccountNumber,
  });

  String _formatCurrency(double value) {
    final NumberFormat numberFormat = NumberFormat('#,##0.00', 'en_US');
    return '₱ ${numberFormat.format(value)}';
  }

  String _maskAccountNumber(String accountNumber) {
    final digitsOnly = accountNumber.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.length <= 4) {
      return '**** ${digitsOnly.substring(0, digitsOnly.length)}';
    }

    final lastFour = digitsOnly.substring(digitsOnly.length - 4);

    final maskedPart = '*' * (digitsOnly.length - 4);

    return '$maskedPart $lastFour';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          gradient: Customgradients.cardAccountGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(102),
              blurRadius: 20,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Logo Container
            Positioned(
              right: 39,
              top: 22,
              child: Opacity(
                opacity: 0.4,
                child: Image.asset(
                  logoAsset ?? 'lib/assets/pictures/emerald_logo_white.png',
                  height: 98,
                ),
              ),
            ),

            // Balance Holder (left tab)
            Positioned(
              left: 0,
              top: 16,
              child: Container(
                height: 33,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isHidden ? '₱ ××××.××' : _formatCurrency(balanceHolder),
                      style: AccountCardStyles.balanceHolderLabel,
                    ),
                    if (limitBalanceHolder != null) ...[
                      const SizedBox(width: 4),
                      Opacity(
                        opacity: 0.4,
                        child: Text(
                          isHidden
                              ? '/ ₱ ××××.××'
                              : '/ ${_formatCurrency(limitBalanceHolder!)}',
                          style: AccountCardStyles.balanceHolderLabel,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Account details
            Positioned(
              left: 16,
              top: 57,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    accountTypeHolder,
                    style: AccountCardStyles.accountTypeLabel,
                  ),
                  const SizedBox(height: 2),
                  Opacity(
                    opacity: 0.6,
                    child: Text(
                      (isAccountNumber == true && isHidden)
                          ? _maskAccountNumber(secondDetail)
                          : secondDetail,
                      style: AccountCardStyles.accountDetails,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Opacity(
                    opacity: 0.6,
                    child: Text(
                      isHidden
                          ? thirdDetail.replaceAll(
                            RegExp(r'₱\s[\d,]+\.\d+'),
                            '₱ ××××.××',
                          )
                          : thirdDetail,
                      style: AccountCardStyles.accountDetails,
                    ),
                  ),
                ],
              ),
            ),

            // Associated Name
            Positioned(
              right: 16,
              bottom: 0,
              child: Container(
                width: 144,
                height: 33,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF044E42),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(102),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    associatedName,
                    style: AccountCardStyles.associatedBankLabel,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
