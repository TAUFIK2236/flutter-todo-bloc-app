import '../../models/api_todo.dart';

abstract class ApiTodoState {}

class ApiTodoLoading extends ApiTodoState {}

class ApiTodoLoaded extends ApiTodoState {
  final List<ApiTodo> todos;

  ApiTodoLoaded(this.todos);
}

class ApiTodoError extends ApiTodoState {
  final String message;

  ApiTodoError(this.message);
}