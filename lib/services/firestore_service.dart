import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/firestore_todo.dart';

class FirestoreService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> saveUserProfile({
    required String userId,
    required String email,
  }) async {
    await firestore.collection('users').doc(userId).set({
      'userId': userId,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<Map<String, dynamic>?> getUserProfile({required String userId}) async {
    final document = await firestore.collection('users').doc(userId).get();

    return document.data();
  }

  Future<void> addTodo({required String userId, required String title}) async {
    await firestore.collection('users').doc(userId).collection('todos').add({
      'title': title,
      'isDone': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<List<FirestoreTodo>> getTodos({required String userId}) async {
    final snapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('todos')
        .orderBy('createdAt', descending: true)
        .get();

    final todos = snapshot.docs.map((doc) {
      return FirestoreTodo.fromJson(id: doc.id, json: doc.data());
    }).toList();

    return todos;
  }

  Future<void> toggleTodo({
    required String userId,
    required String todoId,
    required bool isDone,
  }) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('todos')
        .doc(todoId)
        .update({'isDone': isDone});
  }

  Future<void> deleteTodo({
    required String userId,
    required String todoId,
  }) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('todos')
        .doc(todoId)
        .delete();
  }

  Future<void> updateTodoTitle({
    required String userId,
    required String todoId,
    required String newTitle,
  }) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('todos')
        .doc(todoId)
        .update({'title': newTitle});
  }

Stream<List<FirestoreTodo>> todosStream({
  required String userId,
}) {
  return firestore
      .collection('users')
      .doc(userId)
      .collection('todos')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      return FirestoreTodo.fromJson(
        id: doc.id,
        json: doc.data(),
      );
    }).toList();
  });
}

}
