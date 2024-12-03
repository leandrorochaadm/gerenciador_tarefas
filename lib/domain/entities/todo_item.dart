class TodoItemEntity {
  final int id;
  final String title;
  final String description;
  final bool isDone;

  TodoItemEntity({
    int? id,
    required this.title,
    this.description = '',
    this.isDone = false,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch;
}
