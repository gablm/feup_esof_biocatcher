
import 'dart:math';

import 'package:flutter/material.dart';

class OAuthButton extends StatelessWidget {
  final String text;
  final String logoPath;
  final String? darkLogoPath;
  final Size? size;
  const OAuthButton({
    super.key,
    required this.text,
    required this.logoPath,
    this.darkLogoPath,
    this.size
  });


  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: isDark ? Colors.white : Colors.black,
        backgroundColor: isDark ? Colors.black : Colors.white,
        minimumSize: size
      ),
      onPressed: () {},
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(isDark && darkLogoPath != null ? darkLogoPath ?? '' : logoPath),
              height: 18.0,
              width: 24,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 8),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}