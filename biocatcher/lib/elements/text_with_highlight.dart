import 'package:flutter/material.dart';

class TextWithHighlight extends StatelessWidget {
  TextWithHighlight(this._text, this._highlight, {super.key});

  late String _text;
  late String _highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Text(_text,
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              )),
          Text(
              _highlight,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.inversePrimary,
              ))
        ],
      ),
    );
  }
}
