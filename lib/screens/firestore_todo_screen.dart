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
            appBar: AppBar(title: const Text('Cloud Todos'), centerTitle: true),
            body: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Your cloud-synced tasks',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller,
                              decoration: const InputDecoration(
                                hintText: 'Add a new cloud todo',
                                prefixIcon: Icon(Icons.add_task),
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
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.cloud_done_outlined, size: 64),
                                SizedBox(height: 12),
                                Text(
                                  'No cloud todos yet',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  'Add your first todo above.',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: todos.length,
                          itemBuilder: (context, index) {
                            final todo = todos[index];

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              child: Card(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
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
                                      color: todo.isDone ? Colors.grey : null,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      decoration: todo.isDone
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit_outlined),
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
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          color: Colors.redAccent,
                                        ),
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
