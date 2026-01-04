// lib/core/api_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'constants.dart';

class ApiClient {
  final base = Constants.apiBase;

  Future<Map<String, dynamic>> get(String path, {Map<String, String>? query}) async {
    final uri = Uri.parse('$base/$path').replace(queryParameters: query);
    final res = await http.get(uri).timeout(Constants.timeout);
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
    final res = await http
        .post(Uri.parse('$base/$path'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body))
        .timeout(Constants.timeout);
    return jsonDecode(res.body) as Map<String, dynamic>;
  }
}
