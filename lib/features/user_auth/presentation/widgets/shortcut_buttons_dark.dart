import 'package:flutter/material.dart';

class ShortcutButtonDark extends StatelessWidget {
  final String imagePath;
  final String text;
  final void Function(BuildContext context) onTapCallback;

  const ShortcutButtonDark({
    super.key,
    required this.imagePath,
    required this.text,
    required this.onTapCallback,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTapCallback(context),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 88,
        height: 80,
        decoration: BoxDecoration(
          color: Color(0xFF191919),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ColorFiltered(
              colorFilter: const ColorFilter.mode(
                Color(0xFF06D6A0),
                BlendMode.srcIn,
              ),
              child: Image.asset(
                imagePath,
                width: 30,
                height: 30,
              ),
            ),
            SizedBox(height: 4),
            Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
