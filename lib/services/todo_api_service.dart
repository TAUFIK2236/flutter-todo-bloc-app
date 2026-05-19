import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_todo.dart';

class TodoApiService {//--------------------------------get api------------------------
  Future <List<ApiTodo>> fetchTodos() async{
    final url = Uri.parse('https://jsonplaceholder.typicode.com/todos');
    final response = await http.get(url);
    
    if (response.statusCode==200){
      final List <dynamic> jsonList = jsonDecode(response.body);
      final todos = jsonList.map((json){
        return ApiTodo.fromJson(json);
      }).toList();
      return todos;
    }else{
      throw Exception('Failed to load todos');
    }

  }


Future<ApiTodo> createTodo(String title) async {//-------------------post api-----------------
  final url = Uri.parse('https://jsonplaceholder.typicode.com/todos');

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'userId': 1,
      'title': title,
      'completed': false,
    }),
  );

  if (response.statusCode == 201) {
    final Map<String, dynamic> json = jsonDecode(response.body);

    return ApiTodo.fromJson(json);
  } else {
    throw Exception('Failed to create todo');
  }
}


Future<ApiTodo> updateTodoTitle(int id, String newTitle) async {//-------------------update api-----------------
  final url = Uri.parse('https://jsonplaceholder.typicode.com/todos/$id');

  final response = await http.patch(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'title': newTitle,
    }),
  );
  if (response.statusCode == 200) {
    final Map<String, dynamic> json = jsonDecode(response.body);

    return ApiTodo.fromJson(json);
  } else {
    throw Exception('Failed to update todo');
  }
}

Future<void> deleteTodo(int id) async {//-------------------delete api-----------------
  final url = Uri.parse('https://jsonplaceholder.typicode.com/todos/$id');

  final response = await http.delete(url);

  if (response.statusCode != 200) {
    throw Exception('Failed to delete todo');
  }
}

}