import 'dart:convert';
import 'package:http/http.dart' as http;

class Apilogin {
  static Future<String?> loginUsuario({
    required String email,
    required String senha,
  }) async {
    final url = Uri.parse('http://192.168.0.5:3000/usuarios/entrar');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'senha': senha}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return null; // sucesso
    } else {
      final body = jsonDecode(response.body);
      return body['error'] ?? 'Erro desconhecido';
    }
  }
}
