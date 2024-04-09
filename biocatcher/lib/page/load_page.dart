import 'package:flutter/material.dart';

import '../logic/account.dart';

class LoadPage extends StatefulWidget {
  const LoadPage({super.key});

  @override
  State<LoadPage> createState() => LoadState();
}

class LoadState extends State<LoadPage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 1));
      if (!context.mounted) return;
      if (Account.instance.isSignedIn()) {
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