import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../../repositories/api_todo_repository.dart';

//import '../../services/todo_api_service.dart';
import 'api_todo_event.dart';
import 'api_todo_state.dart';

class ApiTodoBloc extends Bloc<ApiTodoEvent, ApiTodoState> {
final ApiTodoRepository repository;

ApiTodoBloc(this.repository) : super(ApiTodoLoading()) {
    on<LoadApiTodosEvent>(_onLoadApiTodos);
    on<CreateApiTodoEvent>(_onCreateApiTodo);
    on<UpdateApiTodoEvent>(_onUpdateApiTodo);
    on<DeleteApiTodoEvent>(_onDeleteApiTodo);
  }

  Future<void> _onLoadApiTodos(
    //---------for get api-------------
    LoadApiTodosEvent event,
    Emitter<ApiTodoState> emit,
  ) async {
    emit(ApiTodoLoading());

    try {
      final todos = await repository.fetchTodos();
    emit(ApiTodoLoaded(todos: todos));
    } catch (error) {
      emit(ApiTodoError(error.toString()));
    }
  }

Future<void> _onCreateApiTodo(
  CreateApiTodoEvent event,
  Emitter<ApiTodoState> emit,
) async {
  final currentState = state;

  if (currentState is ApiTodoLoaded) {
    emit(
      ApiTodoLoaded(
        todos: currentState.todos,
        isCreating: true,
      ),
    );

    try {
      final createdTodo = await repository.createTodo(event.title);

      final updatedTodos = [
        createdTodo,
        ...currentState.todos,
      ];

      emit(
        ApiTodoLoaded(
          todos: updatedTodos,
          isCreating: false,
        ),
      );
    } catch (error) {
      emit(ApiTodoError(error.toString()));
    }
  }
}

  Future<void> _onUpdateApiTodo(//----------------update the api-------------
    UpdateApiTodoEvent event,
    Emitter<ApiTodoState> emit,
  ) async {
    try {
      final updatedTodo = await repository.updateTodoTitle(
        event.id,
        event.newTitle,
      );

      final currentState = state;

      if (currentState is ApiTodoLoaded) {
        final updatedTodos = [...currentState.todos];

        updatedTodos[event.index] = updatedTodo;

       emit(ApiTodoLoaded(todos: updatedTodos));
      }
    } catch (error) {
      emit(ApiTodoError(error.toString()));
    }
  }

  Future<void> deleteTodo(int id) async {
  final url = Uri.parse('https://jsonplaceholder.typicode.com/todos/$id');

  final response = await http.delete(url);

  if (response.statusCode != 200) {
    throw Exception('Failed to delete todo');
  }
}
Future<void> _onDeleteApiTodo(
  DeleteApiTodoEvent event,
  Emitter<ApiTodoState> emit,
) async {
  try {
    await repository.deleteTodo(event.id);

    final currentState = state;

    if (currentState is ApiTodoLoaded) {
      final updatedTodos = [...currentState.todos];

      updatedTodos.removeAt(event.index);

   emit(ApiTodoLoaded(todos: updatedTodos));
    }
  } catch (error) {
    emit(ApiTodoError(error.toString()));
  }
}
  
}
