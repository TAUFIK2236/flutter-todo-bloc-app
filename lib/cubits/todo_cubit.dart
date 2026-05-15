import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/todo.dart';

class  TodoCubit extends Cubit<List<Todo>> {
  TodoCubit() : super([]);

  Future<void> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();//--->what we declare here? what is the prefs??

    final List<String>? todoJsonList = prefs.getStringList('todos');//-->prefs.getStringList('todos');--what is todos where it can be anything?

    if (todoJsonList == null) {
      return;//--->what this return will do??
    }

    final loadedTodos = todoJsonList.map((todoJson) {//--->make me understand this
      final Map<String, dynamic> todoMap = jsonDecode(todoJson);//--->make me understand this
      return Todo.fromJson(todoMap);//--->make me understand this
    }).toList();

    emit(loadedTodos);//--->make me understand this
  }

  Future<void> saveTodos(List<Todo> todos) async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> todoJsonList = todos.map((todo) {
      return jsonEncode(todo.toJson());
    }).toList();

    await prefs.setStringList('todos', todoJsonList);
  }

  Future<void> addTodo(String title) async {
    final updatedTodos = [
      ...state,//--->meake me understand this why (...)?how it works
      Todo(title: title),
    ];

    emit(updatedTodos);
    await saveTodos(updatedTodos);
  }

  Future<void> deleteTodo(int index) async {
    final updatedTodos = [...state];

    updatedTodos.removeAt(index);

    emit(updatedTodos);
    await saveTodos(updatedTodos);
  }

  Future<void> toggleTodo(int index, bool? value) async {//--->meake me understand this,i forget this again again
    final updatedTodos = [...state];

    updatedTodos[index].isDone = value ?? false;

    emit(updatedTodos);
    await saveTodos(updatedTodos);
  }

  Future<void> editTodo(int index, String newTitle) async {
    final updatedTodos = [...state];

    updatedTodos[index].title = newTitle;

    emit(updatedTodos);
    await saveTodos(updatedTodos);
  }
}