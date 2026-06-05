import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/firestore_todo_repository.dart';
import 'firestore_todo_event.dart';
import 'firestore_todo_state.dart';

class FirestoreTodoBloc extends Bloc<FirestoreTodoEvent, FirestoreTodoState> {
  final FirestoreTodoRepository repository;
  StreamSubscription? _todosSubscription;

  FirestoreTodoBloc(this.repository) : super(FirestoreTodoLoading()) {
    on<LoadFirestoreTodosEvent>(_onLoadTodos);
    on<AddFirestoreTodoEvent>(_onAddTodo);
    on<ToggleFirestoreTodoEvent>(_onToggleTodo);
    on<DeleteFirestoreTodoEvent>(_onDeleteTodo);
    on<UpdateFirestoreTodoTitleEvent>(_onUpdateTodoTitle);
    on<FirestoreTodosUpdatedEvent>(_onTodosUpdated);
  }

  Future<void> _onLoadTodos(
    LoadFirestoreTodosEvent event,
    Emitter<FirestoreTodoState> emit,
  ) async {
    emit(FirestoreTodoLoading());

    await _todosSubscription?.cancel();

    _todosSubscription = repository.todosStream(userId: event.userId).listen(
      (todos) {
        add(FirestoreTodosUpdatedEvent(todos));
      },
      onError: (error) {
        addError(error);
      },
    );
  }

  Future<void> _onAddTodo(
    AddFirestoreTodoEvent event,
    Emitter<FirestoreTodoState> emit,
  ) async {
    try {
      await repository.addTodo(
        userId: event.userId,
        title: event.title,
      );
    } catch (error) {
      emit(FirestoreTodoError(error.toString()));
    }
  }

  Future<void> _onToggleTodo(
    ToggleFirestoreTodoEvent event,
    Emitter<FirestoreTodoState> emit,
  ) async {
    try {
      await repository.toggleTodo(
        userId: event.userId,
        todoId: event.todoId,
        isDone: event.isDone,
      );
    } catch (error) {
      emit(FirestoreTodoError(error.toString()));
    }
  }

  Future<void> _onDeleteTodo(
    DeleteFirestoreTodoEvent event,
    Emitter<FirestoreTodoState> emit,
  ) async {
    try {
      await repository.deleteTodo(
        userId: event.userId,
        todoId: event.todoId,
      );
    } catch (error) {
      emit(FirestoreTodoError(error.toString()));
    }
  }

  Future<void> _onUpdateTodoTitle(
    UpdateFirestoreTodoTitleEvent event,
    Emitter<FirestoreTodoState> emit,
  ) async {
    try {
      await repository.updateTodoTitle(
        userId: event.userId,
        todoId: event.todoId,
        newTitle: event.newTitle,
      );
    } catch (error) {
      emit(FirestoreTodoError(error.toString()));
    }
  }

  void _onTodosUpdated(
    FirestoreTodosUpdatedEvent event,
    Emitter<FirestoreTodoState> emit,
  ) {
    emit(FirestoreTodoLoaded(event.todos));
  }

  @override
  Future<void> close() {
    _todosSubscription?.cancel();
    return super.close();
  }
}