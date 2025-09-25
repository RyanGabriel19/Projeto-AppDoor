import 'dart:convert';
import 'package:frontend/model/models_Usuarios.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Apilogin {
  static const String baseUrl = 'http://172.20.10.2:3000';

  /// Login do usuário. Retorna o token se sucesso ou mensagem de erro iniciada com "Erro:"
  static Future<String?> loginUsuario({
    required String email,
    required String senha,
  }) async {
    final url = Uri.parse('$baseUrl/usuarios/entrar');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'senha': senha}),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (body is Map && body.containsKey('token')) {
          return body['token'];
        } else {
          return 'Erro: Token não encontrado na resposta.';
        }
      } else if (body is Map && body.containsKey('error')) {
        return 'Erro: ${body['error']}';
      } else {
        return 'Erro: Resposta inesperada do servidor.';
      }
    } catch (e) {
      return 'Erro: Falha na conexão com o servidor.';
    }
  }

  /// Busca o perfil do usuário autenticado. Retorna Map com os dados ou null em caso de erro.
  static Future<Usuario?> getPerfilUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwtToken');

    if (token == null || token.trim().isEmpty) {
      print('Token não encontrado.');
      return null;
    }

    print('Token salvo: [$token]');

    final url = Uri.parse('$baseUrl/perfil');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Header correto para JWT
        },
      );

      if (response.statusCode == 200) {
        print('Status code: ${response.statusCode}');
        print('Body da resposta: ${response.body}');
        final body = jsonDecode(response.body);
        final usuario = Usuario.fromJson(body);
        return usuario;
      } else {
        print('Erro ao buscar perfil: ${response.statusCode}');
        print('Resposta: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Erro na requisição do perfil: $e');
      return null;
    }
  }
}
