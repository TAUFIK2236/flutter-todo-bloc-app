class Todo {
  String title;
  bool isDone;

  Todo({required this.title, this.isDone = false});

  Map<String, dynamic> toJson() {
    return {'title': title, 'isDone': isDone};
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    //-->need to understand
    return Todo(title: json['title'], isDone: json['isDone']);
  }
}
