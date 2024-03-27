import 'package:bio_catcher/page/login_page.dart';
import 'package:bio_catcher/page/main_page.dart';
import 'package:bio_catcher/page/mainSections/error_section.dart';
import 'package:flutter/material.dart';
import 'package:bio_catcher/theme/dark_mode.dart';
import 'package:bio_catcher/theme/light_mode.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "BioCatcher",
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      darkTheme: darkMode,
      routes: {
        '/': (context) => LoginPage(),
        '/main': (context) => MainPage(),
      },
      builder: (context, widget) {
        ErrorWidget.builder = (errorDetails) => ErrorSection(error: errorDetails.toStringShort());
        if (widget != null) return widget;
        throw StateError('Widget is null');
      },
    );
  }
}

class ErrorShower extends StatelessWidget {
  final FlutterErrorDetails errorDetails;
  const ErrorShower({super.key, required this.errorDetails});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "BioCatcher",
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      darkTheme: darkMode,
      home: ErrorSection(
          error: errorDetails.exceptionAsString()
      )
    );
  }
}

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    runApp(ErrorShower(errorDetails: details));
  };
  runApp(const App());
}