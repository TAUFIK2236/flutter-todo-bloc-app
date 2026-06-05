import '../../models/firestore_todo.dart';

abstract class FirestoreTodoState {}

class FirestoreTodoLoading extends FirestoreTodoState {}

class FirestoreTodoLoaded extends FirestoreTodoState {
  final List<FirestoreTodo> todos;

  FirestoreTodoLoaded(this.todos);
}

class FirestoreTodoError extends FirestoreTodoState {
  final String message;

  FirestoreTodoError(this.message);
}
