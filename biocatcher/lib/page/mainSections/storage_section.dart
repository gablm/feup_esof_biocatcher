import 'package:flutter/material.dart';

class StorageSection extends StatefulWidget {
  const StorageSection({super.key});

  @override
  State<StorageSection> createState() => StorageState();
}

class StorageState extends State<StorageSection> {
  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text('Storage', style: TextStyle(fontSize: 80))
    );
  }
}