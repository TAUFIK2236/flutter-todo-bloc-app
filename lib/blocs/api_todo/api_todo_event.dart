abstract class ApiTodoEvent {}

class LoadApiTodosEvent extends ApiTodoEvent {}

class CreateApiTodoEvent extends ApiTodoEvent{
  final String title;
  CreateApiTodoEvent(this.title);
}

class UpdateApiTodoEvent extends ApiTodoEvent {
  final int index;
  final int id;
  final String newTitle;

  UpdateApiTodoEvent({
    required this.index,
    required this.id,
    required this.newTitle,
  });
}

class DeleteApiTodoEvent extends ApiTodoEvent {
  final int index;
  final int id;

  DeleteApiTodoEvent({
    required this.index,
    required this.id,
  });
}

