import 'package:flutter/material.dart';

import '../../logic/eventHandler.dart';

class ShopSection extends StatefulWidget {
  const ShopSection({super.key});

  @override
  State<ShopSection> createState() => ShopState();
}

class ShopState extends State<ShopSection> {
  @override
  Widget build(BuildContext context) {
    EventHandler.mainPageAppBar.add(true);
    return const Center(
      child: Text('Shop', style: TextStyle(fontSize: 80))
    );
  }
}