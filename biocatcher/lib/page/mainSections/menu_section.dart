import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MenuSection extends StatefulWidget {
  const MenuSection({super.key});

  @override
  State<MenuSection> createState() => MenuState();
}

class MenuState extends State<MenuSection> {

  Future<void> logOut() async {
    showDialog(
        context: context,
        builder: (context) => const Center(
            child: CircularProgressIndicator()
        ),
        barrierDismissible: false);
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.pop(context);
      Navigator.pushNamed(context, "/");
    }
  }

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
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              child: Text(
                "Log out",
                style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
              ),
              onPressed: () async => logOut(),
            )
          ],
        )
    );
  }
}