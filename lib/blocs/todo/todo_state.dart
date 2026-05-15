import '../../models/todo.dart';

abstract class TodoState {}

class TodoLoaded extends TodoState {
  final List<Todo> todos;

  TodoLoaded(this.todos);
}
//task --->todo api at chatGPT free post,get,update,delete
//this state will has loading ,initial ,loaded and fail