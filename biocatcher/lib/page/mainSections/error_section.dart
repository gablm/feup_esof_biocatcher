import 'package:bio_catcher/main.dart';
import 'package:flutter/material.dart';

import '../../logic/account.dart';
import '../../logic/eventHandler.dart';

class ErrorSection extends StatefulWidget {
  const ErrorSection({super.key, required this.error});
  final String error;

  @override
  State<ErrorSection> createState() => ErrorState();
}

class ErrorState extends State<ErrorSection> {
  @override
  Widget build(BuildContext context) {
    EventHandler.mainPageAppBar.add(false);
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Center(
            child: Padding(padding: const EdgeInsets.all(25.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 100.0,
                          textDirection: TextDirection.ltr
                      ),
                      const SizedBox(height: 10),
                      const Text(
                          "An error occurred",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 30,
                              fontWeight: FontWeight.bold)
                      ),
                      const SizedBox(height: 20),
                      Text(
                          widget.error,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontSize: 20,
                          )
                      ),
                      const SizedBox(height: 50),
                      ElevatedButton(
                          onPressed: () => runApp(App()),
                          child: Text("Go back to BioCatcher",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.inversePrimary,
                                fontSize: 20,
                              )
                          )
                      )
                    ]
                )
            )
        )
    );
  }
}