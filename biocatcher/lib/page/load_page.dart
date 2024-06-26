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
      if (Account.instance.isSignedIn()) {
        try {
          await Account.instance.loadUser();
        } catch (e) {
          await Account.instance.signOut();
          if (!context.mounted) return;
          Navigator.pushNamed(context, "/login");
        }

        if (!context.mounted) return;
        Navigator.pushNamed(context, "/main");
      }
      else {
        if (!context.mounted) return;
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