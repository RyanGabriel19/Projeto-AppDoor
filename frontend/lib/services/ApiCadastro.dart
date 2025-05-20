import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiCadastro {
  static const String baseUrl = 'http://192.168.0.5:3000';

  static Future<bool> cadastrarUsuario({
    required String nome,
    required String sobrenome,
    required String email,
    required String senha,
  }) async {
    final url = Uri.parse('$baseUrl/cadastro');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nome': nome,
        'sobrenome': sobrenome,
        'email': email,
        'senha': senha,
      }),
    );
    // Retorna true se o status code for 200 (OK) ou 201 (Created)
    return response.statusCode == 200 || response.statusCode == 201;
  }
}
