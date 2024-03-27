import 'package:bio_catcher/elements/decorated_text_field.dart';
import 'package:bio_catcher/elements/oauth_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  State<LoginPage> createState() => LoginState();
}

class LoginState extends State<LoginPage> {
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signInWithTwitter() async {
    TwitterAuthProvider twitterProvider = TwitterAuthProvider();
    await FirebaseAuth.instance.signInWithProvider(twitterProvider);
  }

  Future<void> signInWithEmailAndPassword() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: widget.idController.text,
        password: widget.passwordController.text
    );
  }

  void tryToSignIn(String type) async {
    showDialog(
        context: context,
        builder: (context) => const Center(
          child: CircularProgressIndicator()
        ),
        barrierDismissible: false);
    try {
      switch(type) {
        case 'Google':
          await signInWithGoogle();
          break;
        case 'X':
          await signInWithTwitter();
          break;
        default:
          await signInWithEmailAndPassword();
          break;
      }

      if (FirebaseAuth.instance.currentUser == null) {
        throw FirebaseAuthException(code: "invalid-user");
      }

      if (context.mounted) {
        Navigator.pop(context);
        Navigator.pushNamed(context, "/main");
      }
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) {
        return;
      }

      String error = switch (e.code)
      {
        "invalid-credential" => "Invalid user/password",
        "invalid-email" => "Invalid user/password",
        "user-not-found" => "Invalid user/password",
        "user-disabled" => "Invalid user/password",
        _ => "Unknown error"
      };
      Navigator.pop(context);


      FocusManager.instance.primaryFocus?.unfocus();
      showDialog(context: context, builder: (context) => Center(
        child: Container(
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
                "There was an issue during login",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    decoration: TextDecoration.none,
                    backgroundColor: Colors.red,
                    fontSize: 15
                ),
              ),
              const SizedBox(height: 10),
              Text(
                error,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  decoration: TextDecoration.none,
                  backgroundColor: Colors.red,
                  fontSize: 20
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Click anywhere to close",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    decoration: TextDecoration.none,
                    backgroundColor: Colors.red,
                    fontSize: 10
                ),
              )
            ]
          ),
        ),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.pushNamed(context, "/main");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Center(
            child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Row(
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
                      const SizedBox(height: 20),
                      DecoratedTextField(
                        field: "E-mail or Username",
                        controller: widget.idController,
                        obscure: false,
                      ),
                      const SizedBox(height: 10),
                      DecoratedTextField(
                        field: "Password",
                        controller: widget.passwordController,
                        obscure: true,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 150,
                            child: CheckboxListTile(
                                dense: true,
                                controlAffinity: ListTileControlAffinity.leading,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                                title: Transform.translate(
                                  offset: const Offset(-20, 1),
                                  child: Text("Remember me"),
                                ),
                                value: false,
                                onChanged: (keepLogin) {}
                            ),
                          ),
                          InkWell(
                            onTap: () {},
                            child: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text("Forgot your password?"),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(32.0)
                                  ),
                                  minimumSize: const Size(150, 40),
                                ),
                                onPressed: () => {},
                                child: Text("Register",
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.inversePrimary,
                                      fontSize: 20,
                                    )
                                )
                            ),
                            const SizedBox(width: 20),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shadowColor: Colors.greenAccent,
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(32.0)
                                  ),
                                  minimumSize: const Size(150, 40),
                                ),
                                onPressed: () => tryToSignIn(""),
                                child: Text("Login",
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.inversePrimary,
                                      fontSize: 20,
                                    )
                                )
                            ),
                          ]
                      ),
                      const SizedBox(height: 40),
                      OAuthButton(
                        text: "Sign in with Google",
                        logoPath: "assets/google_logo.png",
                        size: const Size(300, 40),
                        onPressed: () async => tryToSignIn('Google'),
                      ),
                      const SizedBox(height: 10),
                      OAuthButton(
                        text: "Sign in with X",
                        logoPath: "assets/x_logo_black.png",
                        darkLogoPath: "assets/x_logo_white.png",
                        size: const Size(300, 40),
                        onPressed: () async => tryToSignIn('X'),
                      ),
                    ]
                )
            ),
        ),
        bottomSheet: TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  side: BorderSide.none,
              ),
              minimumSize: const Size(150, 40),
            ),
            onPressed: () => {
              Navigator.pushNamed(context, "/main")
            },
            child: Text("[Debug] Skip Login",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontSize: 20,
                )
            )
        ),
    );
  }
}