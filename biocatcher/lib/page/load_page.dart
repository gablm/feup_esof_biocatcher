import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoadPage extends StatefulWidget {
  LoadPage({super.key});

  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  State<LoadPage> createState() => LoadState();
}

class LoadState extends State<LoadPage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 3));
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.pushNamed(context, "/main");
      }
      else {
        Navigator.pushNamed(context, "/login");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: const Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Bio",
              style: TextStyle(
                  fontSize: 50,
                  color: Colors.green
              ),
            ),
            Text(
              "Catcher",
              style: TextStyle(fontSize: 50),
            )
          ],
        ),
      )
    );
  }
}