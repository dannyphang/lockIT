// auth_api.dart (example)
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthApi {
  final String baseUrl;
  AuthApi(this.baseUrl);

  Future<String> login(String email, String password) async {
    final r = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (r.statusCode == 200) {
      final data = jsonDecode(r.body) as Map<String, dynamic>;
      return data['token'] as String;
    }
    throw Exception('Invalid credentials');
  }
}
