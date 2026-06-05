import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:test_app/screens/about_screen.dart';
import 'package:test_app/screens/add_todo_screen.dart';
import 'package:test_app/screens/edit_todo_screen.dart';
import 'package:test_app/widgets/todo_tile.dart';

import 'package:test_app/blocs/todo/todo_bloc.dart';
import 'package:test_app/blocs/todo/todo_event.dart';
import 'package:test_app/blocs/todo/todo_state.dart';

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  // This controller reads what the user types in the TextField.

  Future<void> openAddTodoScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTodoScreen()),
    );
    if (!mounted) return;
    if (result == null) {
      return;
    }
    context.read<TodoBloc>().add(AddTodoEvent(result));
    showMessage('Todo added');
  }

  Future<void> openEditTodoScreen(int index, String oldTitle) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTodoScreen(oldTitle: oldTitle),
      ),
    );
    if (!mounted) return;
    if (result == null) {
      return;
    }
    // await context.read<TodoCubit>().editTodo(index, result);
    context.read<TodoBloc>().add(EditTodoEvent(index: index, newTitle: result));

    showMessage('Todo updated');
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }

  Future<void> deleteTodo(int index) async {
    context.read<TodoBloc>().add(DeleteTodoEvent(index));
    //  await context.read<TodoCubit>().deleteTodo(index);
    showMessage('Todo deleted');
  }

  Future<void> toggleTodo(int index, bool? value) async {
    context.read<TodoBloc>().add(ToggleTodoEvent(index: index, value: value));

    showMessage(value == true ? 'Todo completed' : 'Todo marked incomplete');
    // await context.read<TodoCubit>().toggleTodo(index, value);
    // final isDone = context.read<TodoCubit>().state[index].isDone;
    // showMessage(isDone ? 'Todo completed' : 'Todo marked incomplete');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: const Text('Todo App'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: openAddTodoScreen),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: 320,
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                blurRadius: 12,
                offset: Offset(0, 6),
                color: Colors.black26,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'My Todo',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              const SizedBox(height: 20),

              const SizedBox(height: 20),

              // SizedBox(
              //   height: 200,
              //   child: BlocBuilder<TodoCubit, List<Todo>>(
              //     builder: (context, todos) {
              //       return todos.isEmpty
              //           ? const Center(
              //               child: Text(
              //                 'No todos yet.\nAdd your first task!',
              //                 textAlign: TextAlign.center,
              //                 style: TextStyle(
              //                   fontSize: 16,
              //                   color: Colors.grey,
              //                 ),
              //               ),
              //             )
              //           : ListView.builder(
              //               itemCount: todos.length,
              //               itemBuilder: (context, index) {
              //                 return TodoTile(
              //                   todo: todos[index],
              //                   onChanged: (value) {
              //                     toggleTodo(index, value);
              //                   },
              //                   onEdit: () {
              //                     openEditTodoScreen(index, todos[index].title);
              //                   },
              //                   onDelete: () {
              //                     deleteTodo(index);
              //                   },
              //                 );
              //               },
              //             );
              //     },
              //   ),
              // ),
              // SizedBox(
              //   height: 200,
              //   child: BlocBuilder<TodoBloc, TodoState>(
              //     builder: (context, state) {
              //       if (state is TodoLoaded) {
              //         return const Center(child: CircularProgressIndicator());
              //       }

              //       if (state is TodoLoaded) {
              //         final todos = state.todos;

              //         return todos.isEmpty
              //             ? const Center(
              //                 child: Text(
              //                   'No todos yet.\nAdd your first task!',
              //                   textAlign: TextAlign.center,
              //                   style: TextStyle(
              //                     fontSize: 16,
              //                     color: Colors.grey,
              //                   ),
              //                 ),
              //               )
              //             : ListView.builder(
              //                 itemCount: todos.length,
              //                 itemBuilder: (context, index) {
              //                   return TodoTile(
              //                     todo: todos[index],
              //                     onChanged: (value) {
              //                       toggleTodo(index, value);
              //                     },
              //                     onEdit: () {
              //                       openEditTodoScreen(
              //                         index,
              //                         todos[index].title,
              //                       );
              //                     },
              //                     onDelete: () {
              //                       deleteTodo(index);
              //                     },
              //                   );
              //                 },
              //               );
              //       }

              //       return const SizedBox();
              //     },
              //   ),
              // ),
              SizedBox(
                height: 200,
                child: BlocBuilder<TodoBloc, TodoState>(
                  builder: (context, state) {
                    final todos = (state as TodoLoaded).todos;

                    return todos.isEmpty
                        ? const Center(
                            child: Text(
                              'No todos yet.\nAdd your first task!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: todos.length,
                            itemBuilder: (context, index) {
                              return TodoTile(
                                todo: todos[index],
                                onChanged: (value) {
                                  toggleTodo(index, value);
                                },
                                onEdit: () {
                                  openEditTodoScreen(index, todos[index].title);
                                },
                                onDelete: () {
                                  deleteTodo(index);
                                },
                              );
                            },
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
