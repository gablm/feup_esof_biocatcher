import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      background: Colors.grey.shade900,
      primary: Colors.grey.shade700,
      secondary: Colors.grey.shade800,
      inversePrimary: Colors.grey.shade200,
    ),
    textTheme: ThemeData.dark().textTheme.apply(
      bodyColor: Colors.grey.shade200,
      displayColor: Colors.white,
    )
);