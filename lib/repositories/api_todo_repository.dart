import '../models/api_todo.dart';
import '../services/todo_api_service.dart';

class ApiTodoRepository {
  final TodoApiService apiService;

  ApiTodoRepository(this.apiService);

  Future<List<ApiTodo>> fetchTodos() {
    return apiService.fetchTodos();
  }

  Future<ApiTodo> createTodo(String title) {
    return apiService.createTodo(title);
  }

  Future<ApiTodo> updateTodoTitle(int id, String newTitle) {
    return apiService.updateTodoTitle(id, newTitle);
  }

  Future<void> deleteTodo(int id) {
    return apiService.deleteTodo(id);
  }
}
