import 'dart:convert';
import 'api_client.dart';
import 'token_storage.dart';

class AuthService {
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final response = await ApiClient.post('/auth/local', {
      "identifier": email,
      "password": password,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await TokenStorage.saveToken(data['jwt']);
      return data;
    } else {
      throw Exception('Invalid credentials');
    }
  }

  static Future<Map<String, dynamic>> me() async {
    final response = await ApiClient.get('/users/me?populate=role');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    if (response.statusCode == 401) {
      await TokenStorage.clearToken();
      throw Exception('Session expired');
    }

    throw Exception('Unknown error');
  }
}
