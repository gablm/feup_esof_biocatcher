
import 'package:flutter/material.dart';

class DecoratedTextField extends StatelessWidget {
  final String field;
  final bool obscure;
  final TextEditingController controller;

  const DecoratedTextField({
    super.key,
    required this.field,
    required this.controller,
    required this.obscure
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.inversePrimary
          )
        ),
        hintText: field
      ),
      obscureText: obscure,
    );
  }}