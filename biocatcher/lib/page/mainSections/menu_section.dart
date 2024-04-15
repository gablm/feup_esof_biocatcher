import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../logic/account.dart';
import '../../logic/eventHandler.dart';

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
    EventHandler.mainPageAppBar.add(false);
    bool twitterLinked = Account.instance.loginMethods
        .any((element) => element.providerId == "twitter.com");
    bool googleLinked = Account.instance.loginMethods
        .any((element) => element.providerId == "google.com");

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.transparent,
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
      body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                    Account.instance.profile!.picture,
                    fit: BoxFit.cover,
                    width: 64,
                    height: 64,
                  )
              ),
              Text(
                  "${Account.instance.profile?.nickname}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25
                  )
              ),
              Text(
                  "@${Account.instance.profile?.handle}",
                  style: const TextStyle(fontSize: 20)
              ),
              Divider(
                  height: 30,
                  color: Theme.of(context).colorScheme.inversePrimary
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.email_outlined,
                          size: 24
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Text(
                            "${Account.instance.currentUser?.email}",
                            style: TextStyle(
                              fontSize: 17,
                              color: Theme.of(context).colorScheme.inversePrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ]
                  ),
                  ElevatedButton(
                      onPressed: null,
                      child: Text(
                        "Change",
                        style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
                      ),
                    )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                            Icons.key_outlined,
                            size: 24
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Text(
                            "•••••••••••••",
                            style: TextStyle(
                              fontSize: 17,
                              color: Theme.of(context).colorScheme.inversePrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ]
                  ),
                  ElevatedButton(
                    onPressed: null,
                    child: Text(
                      "Change",
                      style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                            Icons.phone_android_outlined,
                            size: 24
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Text(
                            Account.instance.currentUser?.phoneNumber ?? "Unlinked",
                            style: TextStyle(
                              fontSize: 17,
                              color: Theme.of(context).colorScheme.inversePrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ]
                  ),
                  if (true)
                    ElevatedButton(
                      child: Text(
                        "Link",
                        style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
                      ),
                      onPressed: null,
                    ),
                  if (false)
                    ElevatedButton(
                      child: Text(
                        "Unlink",
                        style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
                      ),
                      onPressed: null
                    )
                ],
              ),
              Divider(
                  height: 30,
                  color: Theme.of(context).colorScheme.inversePrimary
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Image(
                        image: AssetImage("assets/google_logo.png"),
                        height: 18.0,
                        width: 24,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Text(
                          "Google",
                          style: TextStyle(
                            fontSize: 17,
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ]
                  ),
                  if (!googleLinked)
                    ElevatedButton(
                    child: Text(
                      "Link",
                      style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
                    ),
                    onPressed: () async {
                      await Account.instance.linkGoogle();
                      setState(() {});
                    },
                  ),
                  if (googleLinked)
                    ElevatedButton(
                    child: Text(
                      "Unlink",
                      style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
                    ),
                    onPressed: () async {
                      await Account.instance.unlink(AuthType.google);
                      setState(() {});
                    },
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Image(
                          image: AssetImage("assets/x_logo_black.png"),
                          height: 18.0,
                          width: 24,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Text(
                            "X (formerly Twitter)",
                            style: TextStyle(
                              fontSize: 17,
                              color: Theme.of(context).colorScheme.inversePrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ]
                  ),
                  if (!twitterLinked)
                    ElevatedButton(
                      child: Text(
                        "Link",
                        style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
                      ),
                      onPressed: () async {
                        await Account.instance.linkTwitter();
                        setState(() {});
                      },
                    ),
                  if (twitterLinked)
                    ElevatedButton(
                      child: Text(
                        "Unlink",
                        style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
                      ),
                      onPressed: () async {
                        await Account.instance.unlink(AuthType.twitter);
                        setState(() {});},
                    )
                ],
              ),
              Divider(
                  height: 30,
                  color: Theme.of(context).colorScheme.inversePrimary
              ),
              ElevatedButton(
                child: Text(
                  "Log out",
                  style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
                ),
                onPressed: () async => logOut(),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red
                ),
                child: const Text(
                  "Delete Account",
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
                onPressed: () async => Account.instance.deleteAccount(),
              ),
              /*Divider(
                  height: 30,
                  color: Theme.of(context).colorScheme.inversePrimary
              ),
              ElevatedButton(
                child: Text(
                  "Add 10 coins",
                  style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
                ),
                onPressed: () {
                  Account.instance.profile?.addCoins(10);
                },
              )*/
            ],
          )
      ),
    );
  }
}