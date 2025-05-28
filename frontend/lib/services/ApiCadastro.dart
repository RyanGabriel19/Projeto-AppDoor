import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiCadastro {
  static const String baseUrl = 'http://192.168.154.110:3000';

  static Future<String?> cadastrarUsuario({
    required String nome,
    required String sobrenome,
    required String usuario,
    required String email,
    required String senha,
  }) async {
    final url = Uri.parse('$baseUrl/usuarios/cadastrar');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nome': nome,
        'sobrenome': sobrenome,
        'usuario': usuario,
        'email': email,
        'senha': senha,
      }),
    );
    // Retorna true se o status code for 200 (OK) ou 201 (Created)
    if (response.statusCode == 200 || response.statusCode == 201) {
      return null; // sucesso
    } else {
      final body = jsonDecode(response.body);
      return body['error'] ?? 'Erro desconhecido';
    }
  }
}
