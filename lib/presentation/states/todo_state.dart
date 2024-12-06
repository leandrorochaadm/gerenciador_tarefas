import '../../domain/entities/todo_item.dart';

abstract class TodoState {}

class TodoStateInitial extends TodoState {}

class TodoStateLoading extends TodoState {}

class TodoStateLoaded extends TodoState {
  final List<TodoItemEntity> todos;
  TodoStateLoaded(this.todos);
}

class TodoStateEmpty extends TodoState {}
