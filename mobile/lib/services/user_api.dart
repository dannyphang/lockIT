import 'dart:convert';
import 'package:http/http.dart' as http;

class UserApi {
  final String baseUrl;
  UserApi(this.baseUrl);

  Future<int> fetchUserPoints(String token) async {
    final r = await http.get(
      Uri.parse('$baseUrl/points'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (r.statusCode == 200) {
      final data = jsonDecode(r.body) as Map<String, dynamic>;
      return data['points'] as int;
    }
    throw Exception('Failed to load points');
  }
}
