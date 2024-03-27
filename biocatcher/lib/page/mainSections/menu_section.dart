import 'package:flutter/material.dart';

class MenuSection extends StatefulWidget {
  const MenuSection({super.key});

  @override
  State<MenuSection> createState() => MenuState();
}

class MenuState extends State<MenuSection> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
                "Menu",
                style: TextStyle(fontSize: 80)
            ),
            ElevatedButton(
              child: Text(
                  "Throw Test",
                style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
              ),
              onPressed: () {
                throw Exception('Throw test'); },
            )
          ],
        )
    );
  }
}