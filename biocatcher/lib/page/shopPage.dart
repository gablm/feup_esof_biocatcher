import 'package:flutter/material.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => ShopState();
}

class ShopState extends State<ShopPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Shop', style: TextStyle(fontSize: 80))
    );
  }
}