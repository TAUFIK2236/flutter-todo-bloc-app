class ApiTodo {
  final int id;
  final String title;
  final bool completed;

  ApiTodo({required this.id, required this.title, required this.completed});

  factory ApiTodo.fromJson(Map<String, dynamic> json) {
    return ApiTodo(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'No title',
      completed: json['completed'] ?? false,
    );
  }
}
