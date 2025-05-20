import 'package:flutter/material.dart';

class sobrenome extends StatelessWidget {
  final TextEditingController controller;

  const sobrenome({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(labelText: 'sobrenome'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'digite seu sobrenome';
        }
        return null;
      },
    );
  }
}
