import 'package:bio_catcher/elements/decorated_text_field.dart';
import 'package:bio_catcher/elements/oauth_button.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  State<LoginPage> createState() => MainState();
}

class MainState extends State<LoginPage> {
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
                                onPressed: () => {},
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
                      const OAuthButton(
                        text: "Sign in with Google",
                        logoPath: "assets/google_logo.png",
                        size: Size(300, 40),
                      ),
                      const SizedBox(height: 10),
                      const OAuthButton(
                        text: "Sign in with X",
                        logoPath: "assets/x_logo_black.png",
                        darkLogoPath: "assets/x_logo_white.png",
                        size: Size(300, 40),
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