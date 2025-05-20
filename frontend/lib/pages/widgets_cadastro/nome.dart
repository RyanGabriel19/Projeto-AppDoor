import 'package:flutter/material.dart';

class nome extends StatelessWidget {
  final TextEditingController controller;

  const nome({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(labelText: "nome"),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "digite seu nome";
        }
        return null;
      },
    );
  }
}
