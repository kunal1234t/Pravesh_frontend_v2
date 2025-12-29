import 'dart:convert';
import 'package:pravesh_screen/services/api_client.dart';

class ExitService {
  static Future<Map<String, dynamic>> submitExitRequest(
      Map<String, dynamic> data) async {
    final response = await ApiClient.post(
      '/exit-requests',
      data,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = jsonDecode(response.body);

      if (decoded is! Map<String, dynamic>) {
        throw Exception('Invalid response from server');
      }

      return decoded;
    } else {
      throw Exception(
        'Exit request failed (${response.statusCode}): ${response.body}',
      );
    }
  }
}
