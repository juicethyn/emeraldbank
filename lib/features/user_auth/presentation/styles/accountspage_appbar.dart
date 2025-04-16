import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AccountsPageAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onEyeToggle;
  final bool eyeEnabled;

  const AccountsPageAppbar({
    super.key,
    required this.title,
    this.onEyeToggle,
    required this.eyeEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withAlpha(64),
        //     blurRadius: 10,
        //     offset: const Offset(0, 0),
        //   ),
        // ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
        ),
        title: Text(title),
        titleTextStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFF044E42),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,

        // Back Button
        leading: Container(
          margin: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: Color(0xFF044E42),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Color(0xFFF8FFE5),
              size: 18,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),

        // Right Button (Eye toggler)
        actions: [
          if (onEyeToggle != null)
            Container(
              margin: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFF044E42),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  eyeEnabled ? Icons.visibility : Icons.visibility_off,
                  color: const Color(0xFFF8FFE5),
                  size: 24,
                ),
                onPressed: onEyeToggle,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
