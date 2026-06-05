class FirestoreTodo {
  final String id;
  final String title;
  final bool isDone;

  FirestoreTodo({required this.id, required this.title, required this.isDone});

  factory FirestoreTodo.fromJson({
    required String id,
    required Map<String, dynamic> json,
  }) {
    return FirestoreTodo(
      id: id,
      title: json['title'] ?? '',
      isDone: json['isDone'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'isDone': isDone};
  }
}
