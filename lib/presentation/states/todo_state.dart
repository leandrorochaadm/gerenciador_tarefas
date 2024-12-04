import '../../domain/entities/todo_item.dart';

abstract class TodoState {}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final List<TodoItemEntity> todos;
  TodoLoaded(this.todos);
}

class TodoEmpty extends TodoState {}

class TodoError extends TodoState {
  final String message;
  TodoError(this.message);
}
