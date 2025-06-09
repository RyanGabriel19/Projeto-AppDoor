import 'dart:convert';
import 'package:frontend/model/models_Usuarios.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Funcoes {
  ///////////////delet usuario

  static const String baseUrl = 'http://192.168.0.5:3000';

  static Future<String> deletUsuario(String idUsuario) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token'); // Se usar token JWT

    final url = Uri.parse('$baseUrl/usuarios/deletar/$idUsuario');

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token', // se usar autenticação
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      return body['error'] ?? 'Operação concluída com sucesso.';
    } else {
      // Tenta extrair a mensagem de erro do corpo da resposta
      final body = jsonDecode(response.body);
      return body['error'] ?? 'Erro desconhecido';
    }
  }

  static Future<String> alterarSenha(
    String id,
    String novaSenha,
    String token,
  ) async {
    final url = Uri.parse('$baseUrl/usuarios/atualizar/$id');

    final Map<String, dynamic> body = {
    'nome': null, 
    'sobrenome': null,
    'usuario': null,
    'email': null,
    'senha': novaSenha};
    
  //   "nome": null,
  // "sobrenome": null,
  // "usuario": "igor",
  // "email": "igor99@gmail.com",
  // "senha": "12345"

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['message'] ?? 'Senha atualizada com sucesso.';
    } else {
      try {
        final json = jsonDecode(response.body);
        throw Exception(
          json['error'] ?? 'Erro desconhecido ao atualizar senha.',
        );
      } catch (e) {
        throw Exception('Erro desconhecido ao atualizar senha.');
      }
    }
  }
}
