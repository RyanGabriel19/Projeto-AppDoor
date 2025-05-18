import 'package:flutter/material.dart';

class email extends StatelessWidget {
  final TextEditingController controller;

  const email({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(labelText: 'email'),
      // validator: (value) {
      //   if (value == null || value.isEmpty) {
      //     return 'digite seu nome';
      //   }
      //   if (!value.contains('@')) {
      //     return 'digite um email valido';
      //   }
      //   return null;
      // },
    );
  }
}
