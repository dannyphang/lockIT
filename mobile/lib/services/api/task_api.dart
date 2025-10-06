import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/task.dart';

class TaskApi {
  final String baseUrl;
  TaskApi(this.baseUrl);

  Future<List<Task>> getAllTasks(String token) async {
    final r = await http.get(
      Uri.parse('$baseUrl/task/allTask'),
      headers: {'Content-Type': 'application/json', 'Authorization': token},
    );

    if (r.statusCode == 200) {
      final data = jsonDecode(r.body);

      final list = (data['data'] as List<dynamic>);
      return list.map((e) => Task.fromJson(e as Map<String, dynamic>)).toList();
    }

    throw Exception('Failed to load tasks: ${r.body}');
  }

  Future<void> completeTask(Task task, String token) async {
    final r = await http.post(
      Uri.parse('$baseUrl/task/complete'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'task': task, 'token': token}),
    );

    if (r.statusCode == 200) {
      // final data = jsonDecode(r.body);
      return;
    }

    throw Exception('Failed to load tasks: ${r.body}');
  }

  Future<void> selectTask(Task task, String token) async {
    final r = await http.post(
      Uri.parse('$baseUrl/task/selectTask'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'taskUid': task.uid, 'token': token}),
    );

    if (r.statusCode == 200) {
      return;
    }

    throw Exception('Failed to load tasks: ${r.body}');
  }
}
