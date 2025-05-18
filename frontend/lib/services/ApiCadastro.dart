import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiCadastro {
  static const String baseUrl = 'http//192.168.0.5:3000';

  static Future<bool> CadastrarUsuario({
    required String nome,
    required String sobrenome,
    required String email,
    required String senha,
  }) async {
    final url = Uri.parse('$baseUrl/cadastro');

    final response = await http.post(
      url,
      headers: {'Conteent-Type': 'application/json'},
      body: JsonEncode({
        'nome': nome,
        'sobrenome': sobrenome,
        'email': email,
        'senha': senha,
      }),
    );
  }
}
