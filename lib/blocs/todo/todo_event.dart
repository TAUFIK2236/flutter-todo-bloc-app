abstract class TodoEvent {}

class LoadTodosEvent extends TodoEvent {}

class AddTodoEvent extends TodoEvent {
  final String title;

  AddTodoEvent(this.title);
}

class DeleteTodoEvent extends TodoEvent {
  final int index;

  DeleteTodoEvent(this.index);
}

class EditTodoEvent extends TodoEvent {
  final int index;
  final String newTitle;

  EditTodoEvent({required this.index, required this.newTitle});
}

class ToggleTodoEvent extends TodoEvent {
  final int index;
  final bool? value;

  ToggleTodoEvent({required this.index, required this.value});
}
