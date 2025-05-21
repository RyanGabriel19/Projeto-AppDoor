import 'package:flutter/material.dart';
import 'package:frontend/pages/login.dart';

// ignore: depend_on_referenced_packages
import 'package:frontend/pages/widgets_cadastro/nome.dart';
import 'package:frontend/pages/widgets_cadastro/usuario.dart';

import 'package:frontend/pages/widgets_cadastro/sobrenome.dart';
import 'package:frontend/pages/widgets_cadastro/email.dart';
import 'package:frontend/pages/widgets_cadastro/senha.dart';
// import 'package:frontend/pages/HomePage.dart';
import 'package:frontend/services/ApiCadastro.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final _formKey = GlobalKey<FormState>();

  final nomeController = TextEditingController();
  final sobrenomeController = TextEditingController();
  final usuarioController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  @override
  void dispose() {
    nomeController.dispose();
    sobrenomeController.dispose();
    usuarioController.dispose();
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  void _cadastrar() async {
    if (_formKey.currentState!.validate()) {
      final erro = await ApiCadastro.cadastrarUsuario(
        nome: nomeController.text,
        sobrenome: sobrenomeController.text,
        usuario: usuarioController.text,
        email: emailController.text,
        senha: senhaController.text,
      );

      if (erro == null) {
        // Sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cadastro realizado com sucesso!')),
        );
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        });
      } else {
        // Mostra mensagem de erro que veio da API
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(erro)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Cadastro de Usuário'),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    nome(controller: nomeController),
                    const SizedBox(height: 16),
                    sobrenome(controller: sobrenomeController),
                    const SizedBox(height: 16),
                    usuario(controller: usuarioController),
                    const SizedBox(height: 16),
                    email(controller: emailController),
                    const SizedBox(height: 16),
                    senha(controller: senhaController),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _cadastrar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Cadastrar',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
