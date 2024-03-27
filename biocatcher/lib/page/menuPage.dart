import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => MenuState();
}

class MenuState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Menu", style: TextStyle(fontSize: 80))
    );
  }
}