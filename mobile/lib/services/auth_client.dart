import 'package:http/http.dart' as http;

typedef AsyncTokenGetter = Future<String?> Function();

class AuthClient extends http.BaseClient {
  final http.Client _inner;
  final AsyncTokenGetter _getToken;

  AuthClient(this._inner, this._getToken);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final token = await _getToken();
    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    request.headers['Content-Type'] = 'application/json';
    return _inner.send(request);
  }
}
