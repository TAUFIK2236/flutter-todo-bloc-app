import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/api_todo/api_todo_bloc.dart';
import '../blocs/api_todo/api_todo_event.dart';
import '../blocs/api_todo/api_todo_state.dart';
import '../services/todo_api_service.dart';

class ApiTodoScreen extends StatefulWidget {
  const ApiTodoScreen({super.key});

  @override
  State<ApiTodoScreen> createState() => _ApiTodoScreenState();
}

class _ApiTodoScreenState extends State<ApiTodoScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void createApiTodo(BuildContext context) {//----------api creating
    final title = controller.text;

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a todo'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    context.read<ApiTodoBloc>().add(CreateApiTodoEvent(title));
    controller.clear();
  }

  void showEditDialog({
    required BuildContext context,
    required int index,
    required int id,
    required String oldTitle,
  }) {
    final TextEditingController editController = TextEditingController(
      text: oldTitle,
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit API Todo'),
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
                final newTitle = editController.text;

                if (newTitle.isEmpty) {
                  return;
                }

                context.read<ApiTodoBloc>().add(
                  UpdateApiTodoEvent(index: index, id: id, newTitle: newTitle),
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
    return BlocProvider(
      create: (context) =>
          ApiTodoBloc(TodoApiService())..add(LoadApiTodosEvent()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(title: const Text('API Todos'), centerTitle: true),
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
                            hintText: 'Enter API todo',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          createApiTodo(context);
                        },
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: BlocBuilder<ApiTodoBloc, ApiTodoState>(
                    builder: (context, state) {
                      if (state is ApiTodoLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state is ApiTodoError) {
                        return Center(child: Text(state.message));
                      }

                      if (state is ApiTodoLoaded) {
                        final todos = state.todos;

                        return ListView.builder(
                          itemCount: todos.length,
                          itemBuilder: (context, index) {
                            final todo = todos[index];

                            return Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Text(todo.id.toString()),
                                ),
                                title: Text(todo.title),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      todo.completed
                                          ? Icons.check_circle
                                          : Icons.radio_button_unchecked,
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        showEditDialog(
                                          context: context,
                                          index: index,
                                          id: todo.id,
                                          oldTitle: todo.title,
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        context.read<ApiTodoBloc>().add(
                                          DeleteApiTodoEvent(
                                            index: index,
                                            id: todo.id,
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
