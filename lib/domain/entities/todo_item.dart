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
    this.isDone = false,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch,
        description = description ?? '';

  factory TodoItemEntity.fromModel(TodoItemModel todoItemModel) {
    return TodoItemEntity(
      id: todoItemModel.id,
      title: todoItemModel.title,
      description: todoItemModel.description,
      isDone: todoItemModel.isDone,
    );
  }
}
