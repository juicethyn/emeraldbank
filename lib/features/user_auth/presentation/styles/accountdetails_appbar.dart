import 'package:flutter/material.dart';

class AccountDetailsAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const AccountDetailsAppbar({super.key, required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Color(0xFF044E42)),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: AppBar(
        title: Text(title),
        titleTextStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFFF8FFE5),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,

        // Back Button
        leading: Container(
          margin: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: Color(0xFFF8FFE5),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Color(0xFF044E42),
              size: 18,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),

        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
