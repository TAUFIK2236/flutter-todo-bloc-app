import '../../models/api_todo.dart';

abstract class ApiTodoState {}

class ApiTodoLoading extends ApiTodoState {}

class ApiTodoLoaded extends ApiTodoState {
  final List<ApiTodo> todos;
  final bool isCreating;

  ApiTodoLoaded({
    required this.todos,
    this.isCreating = false,
  });
}

class ApiTodoError extends ApiTodoState {
  final String message;

  ApiTodoError(this.message);
}