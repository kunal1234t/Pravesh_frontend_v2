import '../services/api_client.dart';
import 'dart:convert';

class GuardRequestService {
  static Future<Map<String, dynamic>> fetchRequestStatus(
      String requestId) async {
    final response = await ApiClient.get('/guard/requests/$requestId');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception('Failed to load request');
  }
}
