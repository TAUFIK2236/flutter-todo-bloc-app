import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/firestore_todo/firestore_todo_bloc.dart';
import '../blocs/firestore_todo/firestore_todo_event.dart';
import '../blocs/firestore_todo/firestore_todo_state.dart';
import '../repositories/firestore_todo_repository.dart';
import '../services/firestore_service.dart';

class FirestoreTodoScreen extends StatefulWidget {
  const FirestoreTodoScreen({super.key});

  @override
  State<FirestoreTodoScreen> createState() => _FirestoreTodoScreenState();
}

class _FirestoreTodoScreenState extends State<FirestoreTodoScreen> {
  final TextEditingController controller = TextEditingController();

  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void addTodo(BuildContext context) {
    final title = controller.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a todo')));
      return;
    }

    if (currentUser == null) {
      return;
    }

    context.read<FirestoreTodoBloc>().add(
      AddFirestoreTodoEvent(userId: currentUser!.uid, title: title),
    );

    controller.clear();
  }

  void showEditDialog({
    required BuildContext context,
    required String userId,
    required String todoId,
    required String oldTitle,
  }) {
    final TextEditingController editController = TextEditingController(
      text: oldTitle,
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit Firestore Todo'),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(
              hintText: 'Enter new title',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newTitle = editController.text.trim();

                if (newTitle.isEmpty) {
                  return;
                }

                context.read<FirestoreTodoBloc>().add(
                  UpdateFirestoreTodoTitleEvent(
                    userId: userId,
                    todoId: todoId,
                    newTitle: newTitle,
                  ),
                );

                Navigator.pop(dialogContext);
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return const Scaffold(body: Center(child: Text('No user logged in')));
    }

    return BlocProvider(
      create: (context) {
        final firestoreService = FirestoreService();
        final repository = FirestoreTodoRepository(firestoreService);

        return FirestoreTodoBloc(repository)
          ..add(LoadFirestoreTodosEvent(currentUser!.uid));
      },
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Firestore Todos'),
              centerTitle: true,
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                            hintText: 'Enter Firestore todo',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          addTodo(context);
                        },
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: BlocBuilder<FirestoreTodoBloc, FirestoreTodoState>(
                    builder: (context, state) {
                      if (state is FirestoreTodoLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state is FirestoreTodoError) {
                        return Center(child: Text(state.message));
                      }

                      if (state is FirestoreTodoLoaded) {
                        final todos = state.todos;

                        if (todos.isEmpty) {
                          return const Center(
                            child: Text('No Firestore todos yet'),
                          );
                        }

                        return ListView.builder(
                          itemCount: todos.length,
                          itemBuilder: (context, index) {
                            final todo = todos[index];

                            return Card(
                              child: ListTile(
                                leading: Checkbox(
                                  value: todo.isDone,
                                  onChanged: (value) {
                                    context.read<FirestoreTodoBloc>().add(
                                      ToggleFirestoreTodoEvent(
                                        userId: currentUser!.uid,
                                        todoId: todo.id,
                                        isDone: value ?? false,
                                      ),
                                    );
                                  },
                                ),
                                title: Text(
                                  todo.title,
                                  style: TextStyle(
                                    decoration: todo.isDone
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        showEditDialog(
                                          context: context,
                                          userId: currentUser!.uid,
                                          todoId: todo.id,
                                          oldTitle: todo.title,
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        context.read<FirestoreTodoBloc>().add(
                                          DeleteFirestoreTodoEvent(
                                            userId: currentUser!.uid,
                                            todoId: todo.id,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }

                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
