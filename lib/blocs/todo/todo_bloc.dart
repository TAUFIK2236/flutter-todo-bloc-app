import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/todo.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoLoaded([])) {
    on<LoadTodosEvent>(_onLoadTodos);
    on<AddTodoEvent>(_onAddTodo);
    on<DeleteTodoEvent>(_onDeleteTodo);
    on<EditTodoEvent>(_onEditTodo);
    on<ToggleTodoEvent>(_onToggleTodo);
  }

  Future<void> _onLoadTodos(
    LoadTodosEvent event,
    Emitter<TodoState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final List<String>? todoJsonList = prefs.getStringList('todos');

    if (todoJsonList == null) {
      emit(TodoLoaded([]));
      return;
    }

    final loadedTodos = todoJsonList.map((todoJson) {
      final Map<String, dynamic> todoMap = jsonDecode(todoJson);
      return Todo.fromJson(todoMap);
    }).toList();

    emit(TodoLoaded(loadedTodos));
  }

  Future<void> _saveTodos(List<Todo> todos) async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> todoJsonList = todos.map((todo) {
      return jsonEncode(todo.toJson());
    }).toList();

    await prefs.setStringList('todos', todoJsonList);
  }

  Future<void> _onAddTodo(AddTodoEvent event, Emitter<TodoState> emit) async {
    final currentState = state as TodoLoaded;

    final updatedTodos = [...currentState.todos, Todo(title: event.title)];

    emit(TodoLoaded(updatedTodos));
    await _saveTodos(updatedTodos);
  }

  Future<void> _onDeleteTodo(
    DeleteTodoEvent event,
    Emitter<TodoState> emit,
  ) async {
    final currentState = state as TodoLoaded;

    final updatedTodos = [...currentState.todos];

    updatedTodos.removeAt(event.index);

    emit(TodoLoaded(updatedTodos));
    await _saveTodos(updatedTodos);
  }

  Future<void> _onEditTodo(EditTodoEvent event, Emitter<TodoState> emit) async {
    final currentState = state as TodoLoaded;

    final updatedTodos = [...currentState.todos];

    updatedTodos[event.index].title = event.newTitle;

    emit(TodoLoaded(updatedTodos));
    await _saveTodos(updatedTodos);
  }

  Future<void> _onToggleTodo(
    ToggleTodoEvent event,
    Emitter<TodoState> emit,
  ) async {
    final currentState = state as TodoLoaded;

    final updatedTodos = [...currentState.todos];

    updatedTodos[event.index].isDone = event.value ?? false;

    emit(TodoLoaded(updatedTodos));
    await _saveTodos(updatedTodos);
  }
}
