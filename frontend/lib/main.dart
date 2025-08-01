import 'package:flutter/material.dart';
import 'package:frontend/pages/alteraSenha.dart';
import 'pages/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Door',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/login', //  rota inicial
      routes: {
        '/login': (context) => LoginPage(),
         '/mudarsenha': (context) => AlterarSenhaPage(),// Rota nomeada para LoginPage
        
      },
    );
  }
}
