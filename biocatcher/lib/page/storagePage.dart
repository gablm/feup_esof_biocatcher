import 'package:flutter/material.dart';

class StoragePage extends StatefulWidget {
  const StoragePage({super.key});

  @override
  State<StoragePage> createState() => StorageState();
}

class StorageState extends State<StoragePage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text('Storage', style: TextStyle(fontSize: 80))
    );
  }
}