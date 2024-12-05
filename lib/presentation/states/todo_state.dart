import '../../domain/entities/todo_item.dart';

abstract class TodoState {}

class TodoStateInitial extends TodoState {}

class TodoStateLoading extends TodoState {}

class TodoStateLoaded extends TodoState {
  final List<TodoItemEntity> todos;

  TodoStateLoaded(this.todos);
}

class TodoStateSuccess extends TodoStateLoaded {
  final String message;
  TodoStateSuccess(super.todos, {required this.message});
}

class TodoStateFail extends TodoStateLoaded {
  final String message;
  TodoStateFail(super.todos, {required this.message});
}

class TodoStateUndo extends TodoStateLoaded {
  final String message;
  TodoStateUndo(super.todos, {required this.message});
}

class TodoStateEmpty extends TodoState {}
