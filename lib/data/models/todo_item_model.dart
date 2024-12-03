import '../../domain/entities/todo_item.dart';

class TodoItemModel {
  final int id;
  final String title;
  final String description;
  final bool isDone;

  TodoItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isDone,
  });

  factory TodoItemModel.fromJson(Map<String, dynamic> json) {
    return TodoItemModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      isDone: json['isDone'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isDone': isDone,
    };
  }

  factory TodoItemModel.fromEntity(TodoItemEntity entity) {
    return TodoItemModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      isDone: entity.isDone,
    );
  }

  TodoItemEntity toEntity() {
    return TodoItemEntity(
      id: id,
      title: title,
      description: description,
      isDone: isDone,
    );
  }
}
