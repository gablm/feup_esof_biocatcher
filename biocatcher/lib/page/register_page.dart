import 'package:flutter/material.dart';
import 'package:bio_catcher/elements/decorated_text_field.dart';
import '../logic/account.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController handleController = TextEditingController();

  void _register() async {
    try {
      await Account.registerUser(
        nameController.text,
        emailController.text,
        passwordController.text,
        handleController.text,
      );

      if (!context.mounted) return;
      Navigator.pushNamed(context, "/main");
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Registration Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Register',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 40),
            DecoratedTextField(
              field: "Name",
              controller: nameController,
              obscure: false,
            ),
            const SizedBox(height: 20),
            DecoratedTextField(
              field: "Email",
              controller: emailController,
              obscure: false,
            ),
            const SizedBox(height: 20),
            DecoratedTextField(
              field: "Password",
              controller: passwordController,
              obscure: true,
            ),
            const SizedBox(height: 20),
            DecoratedTextField(
              field: "Handle (e.g., @username)",
              controller: handleController,
              obscure: false,
            ),
            const SizedBox(height: 40),
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
                onPressed: _register,
                child: Text("Register",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 20,
                    )
                )
            ),
          ],
        ),
      ),
    );
  }
}
