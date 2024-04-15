import 'package:flutter/material.dart';

import '../../logic/account.dart';

class ShopSection extends StatefulWidget {
  const ShopSection({super.key});

  @override
  State<ShopSection> createState() => ShopState();
}

class ShopState extends State<ShopSection> {
  @override
  Widget build(BuildContext context) {
    Account.instance.profile?.triggerUserDataEvent("enableAppBar");
    return const Center(
      child: Text('Shop', style: TextStyle(fontSize: 80))
    );
  }
}