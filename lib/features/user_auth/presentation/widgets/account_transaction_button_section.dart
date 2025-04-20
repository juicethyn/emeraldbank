import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AccountTransactionButtonSection {
  final String label;
  final String iconPath;
  final VoidCallback onTap;

  AccountTransactionButtonSection({
    required this.label,
    required this.iconPath,
    required this.onTap,
  });
}

class TransactionButtonRow extends StatelessWidget {
  final List<AccountTransactionButtonSection> buttons;
  final double gap;
  final EdgeInsetsGeometry padding;
  final bool centerButtons;

  const TransactionButtonRow({
    super.key,
    required this.buttons,
    this.gap = 24,
    this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
    this.centerButtons = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(64),
            blurRadius: 10,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      padding: padding,
      child: Row(
        mainAxisAlignment:
            centerButtons ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          ...buttons.asMap().entries.map((entry) {
            final button = entry.value;
            final isLast = entry.key == buttons.length - 1;

            return Padding(
              padding: EdgeInsets.only(right: isLast ? 0 : gap),
              child: GestureDetector(
                onTap: button.onTap,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      button.iconPath,
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(
                        const Color(0xFF044E42),
                        BlendMode.srcIn,
                      ),
                    ),

                    const SizedBox(height: 4),

                    SizedBox(
                      width: 44,
                      child: Text(
                        button.label,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xB3000000),
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
