import 'package:flutter/material.dart';
import 'package:frontend/pages/cadastro.dart';
import 'package:frontend/pages/HomePage.dart';
import 'package:frontend/pages/HomePage_Admin.dart';
import 'package:frontend/pages/widgets_cadastro/email.dart';
import 'package:frontend/pages/widgets_cadastro/senha.dart';
import 'package:frontend/services/ApiLogin.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  Future<void> fazerLogin() async {
    if (_formKey.currentState!.validate()) {
      final erro = await Apilogin.loginUsuario(
        email: emailController.text,
        senha: senhaController.text,
      );

      if (erro == null && emailController.text == 'admin@gmail.com') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login realizado com sucesso!')),
        );
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage_admin()),
          );
        });
      } else if (erro == null && emailController.text != 'admin@gmail.com') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login realizado com sucesso!')),
        );
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        });
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(erro ?? 'erro desconhecido')));
      }
    }
  }

  void IrCadastro() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Cadastro()),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3E8EDE), Color(0xFF6DB6F5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Card(
              color: Colors.white,
              elevation: 12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.lock_open_rounded,
                        size: 64,
                        color: Color(0xFF3E8EDE),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Bem-vindo de volta!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3E8EDE),
                        ),
                      ),
                      const SizedBox(height: 24),
                      email(controller: emailController),
                      const SizedBox(height: 16),
                      senha(controller: senhaController),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: fazerLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Entrar',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: IrCadastro,
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(text: 'Não tem conta? '),
                              TextSpan(
                                text: 'Cadastre-se',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ],
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
      ),
    );
  }
}
