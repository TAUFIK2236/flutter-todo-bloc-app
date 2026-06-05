import '../../models/firestore_todo.dart';

abstract class FirestoreTodoEvent {}

class LoadFirestoreTodosEvent extends FirestoreTodoEvent {
  final String userId;

  LoadFirestoreTodosEvent(this.userId);
}

class AddFirestoreTodoEvent extends FirestoreTodoEvent {
  final String userId;
  final String title;

  AddFirestoreTodoEvent({required this.userId, required this.title});
}

class ToggleFirestoreTodoEvent extends FirestoreTodoEvent {
  final String userId;
  final String todoId;
  final bool isDone;

  ToggleFirestoreTodoEvent({
    required this.userId,
    required this.todoId,
    required this.isDone,
  });
}

class DeleteFirestoreTodoEvent extends FirestoreTodoEvent {
  final String userId;
  final String todoId;

  DeleteFirestoreTodoEvent({required this.userId, required this.todoId});
}

class UpdateFirestoreTodoTitleEvent extends FirestoreTodoEvent {
  final String userId;
  final String todoId;
  final String newTitle;

  UpdateFirestoreTodoTitleEvent({
    required this.userId,
    required this.todoId,
    required this.newTitle,
  });
}

class FirestoreTodosUpdatedEvent extends FirestoreTodoEvent {
  final List<FirestoreTodo> todos;

  FirestoreTodosUpdatedEvent(this.todos);
}
