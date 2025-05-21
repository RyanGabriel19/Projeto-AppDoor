import 'package:flutter/material.dart';

class usuario extends StatelessWidget {
  final TextEditingController controller;

  const usuario({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(labelText: "Usuario"),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "digite seu nome";
        }
        return null;
      },
    );
  }
}
