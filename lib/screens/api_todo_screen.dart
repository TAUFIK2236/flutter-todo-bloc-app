import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/api_todo/api_todo_bloc.dart';
import '../blocs/api_todo/api_todo_event.dart';
import '../blocs/api_todo/api_todo_state.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import '../services/todo_api_service.dart';
import '../repositories/api_todo_repository.dart';

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

  void createApiTodo(BuildContext context) {
    //----------api creating
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
      create: (context) {
        final apiService = TodoApiService();
        final repository = ApiTodoRepository(apiService);

        return ApiTodoBloc(repository)..add(LoadApiTodosEvent());
      },
      child: Builder(
        builder: (context) {
           return BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthUserLoaded) {
              final firstName = state.userData['firstName'];
              final lastName = state.userData['lastName'];

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Current user: $firstName $lastName'),
                  duration: const Duration(seconds: 2),
                ),
              );
            }

            if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
          child: 
           Scaffold(
            appBar: AppBar(
              title: const Text('API Todos'),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: () {
                    context.read<AuthBloc>().add(GetCurrentUserEvent());
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    context.read<AuthBloc>().add(LogoutRequestedEvent());
                  },
                ),
              ],
            ),
            body: Column(
                children: [
                  BlocBuilder<ApiTodoBloc, ApiTodoState>(
                    builder: (context, state) {
                      final bool isCreating =
                          state is ApiTodoLoaded && state.isCreating;

                      return Padding(
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
                              onPressed: isCreating
                                  ? null
                                  : () {
                                      createApiTodo(context);
                                    },
                              child: isCreating
                                  ? const SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text('Add'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: BlocConsumer<ApiTodoBloc, ApiTodoState>(
                      listener: (context, state) {
                        if (state is ApiTodoError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.message),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is ApiTodoLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (state is ApiTodoError) {
                          return Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  state.message,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  onPressed: () {
                                    context.read<ApiTodoBloc>().add(
                                      LoadApiTodosEvent(),
                                    );
                                  },
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          );
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
            ),
          );
        },
      ),
    );
  }
}
