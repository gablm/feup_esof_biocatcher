import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../logic/account.dart';

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
    await Account.instance.signOut();
    if (context.mounted) {
      Navigator.pop(context);
      Navigator.pushNamed(context, "/");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Column(
          children: [
            Text(
                "UserId ${Account.instance.userId}",
                style: const TextStyle(
                  fontSize: 15,
                )
            ),
            for (UserInfo info in Account.instance.loginMethods)
              Text(
                  "${info.providerId} - ${info.uid}" ,
                  style: const TextStyle(
                    fontSize: 15,
                  )
              )
          ],
        ),
      ),
      body: Center(
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
              ),
              ElevatedButton(
                child: Text(
                  "Link Twitter",
                  style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
                ),
                onPressed: () async => Account.instance.linkTwitter(),
              ),
              ElevatedButton(
                child: Text(
                  "Unlink Twitter",
                  style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
                ),
                onPressed: () async => Account.instance.unlink(AuthType.twitter),
              ),
              ElevatedButton(
                child: Text(
                  "Delete Account",
                  style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
                ),
                onPressed: () async => Account.instance.deleteAccount(),
              ),
              ElevatedButton(
                child: Text(
                  "Add 10 coins",
                  style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
                ),
                onPressed: () {
                  Account.instance.profile?.addCoins(10);
                },
              )
            ],
          )
      ),
    );
  }
}