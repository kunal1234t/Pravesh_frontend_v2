import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/env.dart';
import 'token_storage.dart';

class ApiClient {
  static Future<http.Response> get(String path) async {
    final token = await TokenStorage.getToken();

    return http.get(
      Uri.parse('${Env.baseUrl}$path'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
  }

  static Future<http.Response> post(
      String path, Map<String, dynamic> body) async {
    final token = await TokenStorage.getToken();

    return http.post(
      Uri.parse('${Env.baseUrl}$path'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
  }
}
