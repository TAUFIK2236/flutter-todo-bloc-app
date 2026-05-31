import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthService {
  Future<String> login({
    required String username,
    required String password,
  }) async {
    final url = Uri.parse('https://dummyjson.com/auth/login');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);

      return json['accessToken'];
    } else {
      throw Exception('Login failed');
    }
  }


Future<Map<String, dynamic>> getCurrentUser(String token) async {
  final url = Uri.parse('https://dummyjson.com/auth/me');

  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> json = jsonDecode(response.body);
    return json;
  } else {
    throw Exception('Failed to get current user');
  }
}


}