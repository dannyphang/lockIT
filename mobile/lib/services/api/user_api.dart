// lib/core/network/user_api.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/web.dart';

import '../../models/models.dart';

class UserApi {
  final String baseUrl;
  UserApi(this.baseUrl);

  Future<PointTransaction> fetchUserPoints(String token) async {
    final r = await http.get(
      Uri.parse('$baseUrl/points'),
      headers: {'Authorization': token},
    );
    if (r.statusCode == 200) {
      final data = jsonDecode(r.body) as Map<String, dynamic>;
      return PointTransaction.fromJson(data['data'] as Map<String, dynamic>);
    }
    throw Exception('Failed to load points');
  }

  Future<Map<String, dynamic>> fetchUserById(String token, String id) async {
    final r = await http.get(
      Uri.parse('$baseUrl/user/$id'),
      headers: {'Authorization': token},
    );
    if (r.statusCode == 200) {
      return jsonDecode(r.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to load user');
  }

  // Optional: current user endpoint if your backend supports it
  Future<Map<String, dynamic>> fetchMe(String token) async {
    final r = await http.get(
      Uri.parse('$baseUrl/user/me'),
      headers: {'Authorization': token},
    );
    if (r.statusCode == 200) {
      return jsonDecode(r.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to load current user');
  }

  // Optional: update profile
  Future<Map<String, dynamic>> updateMe(
    String token, {
    String? displayName,
    String? email,
    String? avatarUrl,
  }) async {
    final r = await http.put(
      Uri.parse('$baseUrl/user/auth/me'),
      headers: {'Authorization': token, 'Content-Type': 'application/json'},
      body: jsonEncode({
        if (displayName != null) 'displayName': displayName,
        if (email != null) 'email': email,
        if (avatarUrl != null) 'avatarUrl': avatarUrl,
      }),
    );
    if (r.statusCode == 200) {
      return jsonDecode(r.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to update user');
  }

  Future<String> uploadAvatar(XFile? imageFile, String token) async {
    try {
      var uri = Uri.parse('$baseUrl/user/auth/avatar');

      var request = http.MultipartRequest("POST", uri);
      request.headers['Authorization'] = token;

      final size = await imageFile?.length();
      Logger().d({
        'name': imageFile?.name,
        'path': imageFile?.path,
        'size': size,
        'mime': imageFile?.mimeType,
      });

      if (imageFile != null) {
        if (kIsWeb) {
          // ✅ Web: use fromBytes
          final bytes = await imageFile.readAsBytes();

          final filename = imageFile.name.isNotEmpty
              ? imageFile.name
              : "avatar.png";

          MediaType mediaType;
          String ext = filename.split('.').last.toLowerCase();
          if (ext == "jpg" || ext == "jpeg") {
            mediaType = MediaType('image', 'jpeg');
          } else if (ext == "png") {
            mediaType = MediaType('image', 'png');
          } else {
            mediaType = MediaType('application', 'octet-stream');
          }

          request.files.add(
            http.MultipartFile.fromBytes(
              "avatar",
              bytes,
              filename: filename,
              contentType: mediaType,
            ),
          );
        } else {
          // ✅ Mobile/Desktop: use fromPath
          request.files.add(
            await http.MultipartFile.fromPath("avatar", imageFile.path),
          );
        }

        // Send request
        var response = await request.send();

        if (response.statusCode == 200) {
          return response.stream.bytesToString().then((value) {
            final res = jsonDecode(value);
            print("✅ Upload successful: $res");
            return res['data'] as String;
          });
        } else {
          print("❌ Upload failed: ${response.statusCode}");
        }
      }

      return '';
    } catch (e) {
      print("⚠️ Error uploading: $e");
      return '';
    }
  }
}

class PointTransactionApi {
  final String baseUrl;
  PointTransactionApi(this.baseUrl);

  Future<List<PointTransaction>> getAllTransactions(
    String userUid,
    int? pageSize,
  ) async {
    final r = await http.get(
      Uri.parse('$baseUrl/user/userPoints/$userUid'),
      headers: {
        'Content-Type': 'application/json',
        'pagesize': pageSize?.toString() ?? '99999',
      },
    );

    if (r.statusCode == 200) {
      final res = jsonDecode(r.body);

      final list = (res['data'] as List<dynamic>);
      return list
          .map((e) => PointTransaction.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Failed to load transactions: ${r.body}');
  }
}
