import "package:flutter/material.dart";

class senha extends StatelessWidget {
  final TextEditingController controller;
  const senha({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration: const InputDecoration(labelText: 'senha'),
      // validator: (value) {
      //   if (value == null || value.isEmpty) {
      //     return "digite sua senha";
      //   }
      //   if (value.length < 6) {
      //     return 'A senha deve ter no mínimo 6 caracteres';
      //   }
      //   return null;
      // },
    );
  }
}
