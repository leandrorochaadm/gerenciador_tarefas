import '../../data/models/todo_item_model.dart';

class TodoItemEntity {
  final int id;
  final String title;
  final String description;
  final bool isDone;

  TodoItemEntity({
    int? id,
    required this.title,
    String? description = '',
    bool? isDone,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch,
        description = description ?? '',
        isDone = isDone ?? false;

  factory TodoItemEntity.fromModel(TodoItemModel todoItemModel) {
    return TodoItemEntity(
      id: todoItemModel.id,
      title: todoItemModel.title,
      description: todoItemModel.description,
      isDone: todoItemModel.isDone,
    );
  }

  TodoItemEntity copyWith({
    int? id,
    String? title,
    String? description,
    bool? isDone,
  }) {
    return TodoItemEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
    );
  }
}
