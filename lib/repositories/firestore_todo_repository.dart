import '../models/firestore_todo.dart';
import '../services/firestore_service.dart';

class FirestoreTodoRepository {
  final FirestoreService firestoreService;

  FirestoreTodoRepository(this.firestoreService);

  Future<void> addTodo({required String userId, required String title}) async {
    await firestoreService.addTodo(userId: userId, title: title);
  }

  Future<List<FirestoreTodo>> getTodos({required String userId}) async {
    final todos = await firestoreService.getTodos(userId: userId);

    return todos;
  }

  Future<void> toggleTodo({
    required String userId,
    required String todoId,
    required bool isDone,
  }) async {
    await firestoreService.toggleTodo(
      userId: userId,
      todoId: todoId,
      isDone: isDone,
    );
  }

  Future<void> deleteTodo({
    required String userId,
    required String todoId,
  }) async {
    await firestoreService.deleteTodo(userId: userId, todoId: todoId);
  }

  Future<void> updateTodoTitle({
    required String userId,
    required String todoId,
    required String newTitle,
  }) async {
    await firestoreService.updateTodoTitle(
      userId: userId,
      todoId: todoId,
      newTitle: newTitle,
    );
  }

  Stream<List<FirestoreTodo>> todosStream({
  required String userId,
}) {
  return firestoreService.todosStream(
    userId: userId,
  );
}
}
