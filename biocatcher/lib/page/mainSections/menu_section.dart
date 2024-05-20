import 'package:bio_catcher/elements/decorated_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  
  Future<void> changeLink(bool isLinked, AuthType type) async {
    if (isLinked) {
      if (Account.instance.loginMethods.length > 1) {
        await Account.instance.unlink(type);
        setState(() {});
        return;
      }
      FocusManager.instance.primaryFocus?.unfocus();
      showDialog(
          context: context,
          builder: (context) => Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.red
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.warning,
                      color: Colors.white,
                      size: 50,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "You need at least one login method associated to the account.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.bold,
                          backgroundColor: Colors.red,
                          fontSize: 15
                      ),
                    )
                  ]
              ),
            ),
          ));
      return;
    }
    switch (type) {
      case AuthType.twitter:
        await Account.instance.linkTwitter();
        break;
      case AuthType.google:
        await Account.instance.linkGoogle();
        break;
      default:
        break;
    }
    setState(() {});
  }

  void changeEmail() {
    TextEditingController controller = TextEditingController();
    bool visible = false;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
      return Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).colorScheme.background
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Changing email",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Old email: ${Account.instance.currentUser?.email}",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.bold,
                      fontSize: 15
                  ),
                ),
                const SizedBox(height: 10),
                Material(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).colorScheme.primary,
                  child: DecoratedTextField(
                      field: "New Email",
                      controller: controller,
                      obscure: false
                  ),
                ),
                const SizedBox(height: 10),
                if (visible)
                  const Text(
                    "Invalid email or already in use",
                    style: TextStyle(
                        color: Colors.red,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.bold,
                        fontSize: 15
                    ),
                  ),
                if (visible)
                  const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                            "Close",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.inversePrimary,
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.bold,
                                fontSize: 15
                            )
                        )
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if (await Account.instance.isEmailInUse(controller.text)) {
                            visible = true;
                            setState(() {});
                            return;
                          }
                          if (context.mounted) Navigator.pop(context);
                          await Account.instance.reAuthenticate();
                          await Account.instance.currentUser
                              ?.verifyBeforeUpdateEmail(controller.text);
                        },
                        child: Text(
                            "Save",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.inversePrimary,
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.bold,
                                fontSize: 15
                            )
                        )
                    )
                  ],
                )
              ]
          ),
        ),
      );
    });
  }

  void changePw() {
    TextEditingController controller = TextEditingController();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).colorScheme.background
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Changing password",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),
                    ),
                    const SizedBox(height: 10),
                    Material(
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(context).colorScheme.primary,
                      child: DecoratedTextField(
                          field: "New Password",
                          controller: controller,
                          obscure: true
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                                "Close",
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.inversePrimary,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15
                                )
                            )
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await Account.instance.reAuthenticate();
                              await Account.instance.currentUser
                                  ?.updatePassword(controller.text);
                            },
                            child: Text(
                                "Save",
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.inversePrimary,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15
                                )
                            )
                        )
                      ],
                    ),
                  ]
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    EventHandler.mainPageAppBar.add(false);
    bool twitterLinked = Account.instance.loginMethods
        .any((element) => element.providerId == "twitter.com");
    bool googleLinked = Account.instance.loginMethods
        .any((element) => element.providerId == "google.com");

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: true ? null : AppBar(
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
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Text(
                              "${Account.instance.currentUser?.email}",
                              style: TextStyle(
                                fontSize: 17,
                                color: Theme.of(context).colorScheme.inversePrimary,
                                fontWeight: FontWeight.w600,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                        )
                      ]
                  ),
                  ElevatedButton(
                      onPressed: () => changeEmail(),
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
                    onPressed: () => changePw(),
                    child: Text(
                      "Change",
                      style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
                    ),
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
                  ElevatedButton(
                    child: Text(
                      googleLinked ? "Unlink" : "Link",
                      style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
                    ),
                    onPressed: () async => changeLink(googleLinked, AuthType.google),
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
                  ElevatedButton(
                    child: Text(
                      twitterLinked ? "Unlink" : "Link",
                      style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
                    ),
                    onPressed: () async => changeLink(twitterLinked, AuthType.twitter),
                  ),
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