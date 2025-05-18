import 'package:flutter/material.dart';

class botao_enviar extends StatelessWidget {
  final VoidCallback onPressed;

  const botao_enviar({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, child: const Text('Cadastrar'));
  }
}
