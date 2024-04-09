import 'package:bio_catcher/page/load_page.dart';
import 'package:bio_catcher/page/login_page.dart';
import 'package:bio_catcher/page/main_page.dart';
import 'package:bio_catcher/page/mainSections/error_section.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:bio_catcher/theme/dark_mode.dart';
import 'package:bio_catcher/theme/light_mode.dart';

class App extends StatelessWidget {
  App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "BioCatcher",
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      darkTheme: darkMode,
      routes: {
        '/': (context) => LoadPage(),
        '/login': (context) => LoginPage(),
        '/main': (context) => MainPage(),
      },
      builder: (context, widget) {
        ErrorWidget.builder = (errorDetails) => ErrorSection(error: errorDetails.toStringShort());
        return widget!;
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    runApp(ErrorShower(errorDetails: details));
  };
  runApp(App());
}