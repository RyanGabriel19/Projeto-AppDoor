import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Apilogin {
  static const String baseUrl = 'http://192.168.154.110:3000';
  static Future<String?> loginUsuario({
    required String email,
    required String senha,
  }) async {
    final url = Uri.parse('$baseUrl/usuarios/entrar');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'senha': senha}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = jsonDecode(response.body);
      return body['token']; // sucesso
    } else {
      final body = jsonDecode(response.body);
      return body['error'] ?? 'Erro desconhecido';
    }
  }

  //get perfil de usuario
  static Future<Map<String, dynamic>?> getPerfilUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwtToken');

    if (token == null) {
      return null;
    }
    final url = Uri.parse('$baseUrl/perfil');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'applicaton/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Erro ao buscar perfil: ${response.body}');
      return null;
    }
  }
}
