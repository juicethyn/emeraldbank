import 'package:flutter/material.dart';

class AddingAccountFormAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  const AddingAccountFormAppbar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF044E42),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(64),
            blurRadius: 10,
            offset: const Offset(0, 0),
          ),
        ],
      ),
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
        leading: Padding(
          padding: const EdgeInsets.all(12),
          child: InkWell(
            onTap: () => Navigator.of(context).pop(),
            customBorder: const CircleBorder(),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF8FFE5),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Color(0xFF044E42),
                  size: 18,
                ),
              ),
            ),
          ),

          //   IconButton(
          //   onPressed: () => Navigator.of(context).pop(),
          //   icon: const Icon(Icons.arrow_back_ios_new_rounded),
          //   // icon: SvgPicture.asset(
          //   //   'lib/assets/icons/return_customCircularHintYellow.svg',
          //   //   width: 24,
          //   //   height: 24,
          //   // ),
          // ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
