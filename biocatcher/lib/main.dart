import 'package:flutter/material.dart';
import 'package:bio_catcher/page/mapPage.dart';
import 'package:bio_catcher/theme/darkMode.dart';
import 'package:bio_catcher/theme/lightMode.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "BioCatcher",
      debugShowCheckedModeBanner: false,
      home: MapPage(),
      theme: lightMode,
      darkTheme: darkMode,
    );
  }
}
void main() {
  runApp(const App());
}