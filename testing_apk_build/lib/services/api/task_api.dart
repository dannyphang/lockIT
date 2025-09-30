import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/task.dart';

class TaskApi {
  final String baseUrl;
  TaskApi(this.baseUrl);

  Future<List<Task>> getAllTasks() async {
    final r = await http.get(
      Uri.parse('$baseUrl/task/allTask'),
      headers: {'Content-Type': 'application/json'},
    );

    if (r.statusCode == 200) {
      final data = jsonDecode(r.body);

      final list = (data['data'] as List<dynamic>);
      return list.map((e) => Task.fromJson(e as Map<String, dynamic>)).toList();
    }

    throw Exception('Failed to load tasks: ${r.body}');
  }
}
