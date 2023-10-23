import 'package:dio/dio.dart';

class TodoApi {
  static const String baseUrl = 'https://api.nstack.in/v1/todos/';
  Dio http = Dio();

  Future<bool> createTodo(String title, String description) async {
    try {
      final response = await http.post(
        baseUrl,
        data: {
          "title": title,
          "description": description,
          "is_completed": false,
        },
        options: Options(contentType: 'application/json'),
      );
      return true;
    } catch (error) {
      throw Exception('Failed to create todo: $error');
    }
  }

  Future<bool> updateTodo(String id, String title, String description) async {
    try {
      final response = await http.put(
        baseUrl+id,
        data: {
          "title": title,
          "description": description,
          "is_completed": false,
        },
        options: Options(contentType: 'application/json'),
      );
      return true;
    } catch (error) {
      throw Exception('Failed to create todo: $error');
    }
  }

  Future<List> getTodos(String params) async {
    try {
      final response = await http.get(baseUrl + params);
      final json = response.data as Map;
      return json['items'];
    } catch (error) {
      throw Exception('Failed to fetch data. $error');
    }
  }

  Future<bool> deleteTodo(String id) async {
    try {
      final response = await http.delete(baseUrl + id);
      return true;
    } catch (error) {
      throw Exception('Failed to fetch data. $error');
    }
  }
}
