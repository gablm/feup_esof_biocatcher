import 'package:bio_catcher/page/mainPage.dart';
import 'package:bio_catcher/page/mapPage.dart';
import 'package:bio_catcher/page/menuPage.dart';
import 'package:flutter/material.dart';
import 'package:bio_catcher/theme/darkMode.dart';
import 'package:bio_catcher/theme/lightMode.dart';

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
        '/': (context) => MainPage(),
        '/login': (context) => MainPage(),
      },
    );
  }
}
void main() {
  runApp(const App());
}