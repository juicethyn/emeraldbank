import 'package:emeraldbank_mobileapp/features/user_auth/presentation/styles/color_style.dart';
import 'package:emeraldbank_mobileapp/utils/formatting_utils.dart';
import 'package:flutter/material.dart';

class VirtualCardWidget extends StatelessWidget {
  final String accountNumber;
  final String accountHolderName;
  final String cardNumber;
  final String accountType;
  final String associatedHolderName;
  final String expiryDate;
  final bool isHidden;
  final Function()? onVisibilityToggle;

  const VirtualCardWidget({
    super.key,
    required this.accountNumber,
    required this.accountHolderName,
    required this.cardNumber,
    required this.accountType,
    required this.associatedHolderName,
    required this.expiryDate,
    required this.isHidden,
    this.onVisibilityToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 192,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        gradient: Customgradients.cardAccountGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF06D6A0).withAlpha(77),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Top Card Details
          Container(
            height: 128,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: Customgradients.darkGradient,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),

            child: Stack(
              children: [
                // Bank Text Logo
                Positioned(
                  right: 16,
                  top: 12,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: 120,
                    ), // Increased from 53
                    height: 17,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          // Add this to allow text to shrink if needed
                          child: Text(
                            associatedHolderName,
                            overflow:
                                TextOverflow.ellipsis, // Add overflow handling
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF06D6A0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Card Tag Label
                Positioned(
                  left: 0,
                  top: 40,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(12, 4, 16, 4),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 10),
                      ],
                    ),
                    child: Text(
                      accountType,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),

                // Account Number
                Positioned(
                  left: 12,
                  top: 82,
                  child: Row(
                    children: [
                      Text(
                        isHidden
                            ? hideAccountNumber(accountNumber)
                            : formatAccountNumber(accountNumber),
                        style: const TextStyle(
                          fontFamily: 'Fira Code',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.5,
                          color: Color(0xFF06D6A0),
                        ),
                      ),
                      const SizedBox(width: 16),
                      InkWell(
                        onTap: onVisibilityToggle,
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(
                            isHidden ? Icons.visibility_off : Icons.visibility,
                            color: const Color(0xFF06D6A0),
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Expiry Date
                Positioned(
                  left: 12,
                  top: 110,
                  child: Text(
                    'Exp: $expiryDate',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF06D6A0).withAlpha(204),
                    ),
                  ),
                ),

                // Logo
                Positioned(
                  bottom: -20,
                  right: 16,
                  child: Container(
                    width: 98,
                    height: 98,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'lib/assets/pictures/emerald_logo_white.png',
                        ),
                        fit: BoxFit.contain,
                        opacity: 0.4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Card
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Name & Account
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Name with wrapping
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.55,
                          ),
                          child: Text(
                            isHidden
                                ? 'Hello! ${maskName(accountHolderName)}'
                                : 'Hello! $accountHolderName',
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A1819),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                        ),
                        const SizedBox(height: 2),
                        // Card number
                        Text(
                          isHidden
                              ? hideAccountNumber(cardNumber)
                              : formatAccountNumber(cardNumber),
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1A1819).withAlpha(128),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Chip
                  Image.asset(
                    'lib/assets/pictures/chip.png',
                    width: 40,
                    height: 40,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
