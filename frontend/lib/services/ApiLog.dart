import 'dart:convert';
import 'package:http/http.dart' as http;

class LogService {
  final String baseUrl = 'http://192.168.0.5:3000/logs/consultar';

  Future<List<dynamic>> fetchLogs() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao buscar logs');
    }
  }

  Future<List<dynamic>> fetchLogsPorID(String id) async {
   final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao buscar logs por ID');
    }
  }
}
