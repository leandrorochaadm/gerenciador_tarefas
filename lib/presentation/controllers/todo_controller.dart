import 'package:flutter/material.dart';

import '../../domain/entities/todo_item.dart';
import '../../domain/use_cases/create_todo_use_case.dart';
import '../../domain/use_cases/delete_todo_use_case.dart';
import '../../domain/use_cases/fetch_todos_use_case.dart';
import '../../domain/use_cases/update_todo_use_case.dart';
import '../states/todo_state.dart';

class TodoController extends ValueNotifier<TodoState> {
  final FetchTodosUseCase fetchTodosUseCase;
  final CreateTodoUseCase createTodoUseCase;
  final UpdateTodoUseCase updateTodoUseCase;
  final DeleteTodoUseCase deleteTodoUseCase;

  TodoController({
    required this.fetchTodosUseCase,
    required this.createTodoUseCase,
    required this.updateTodoUseCase,
    required this.deleteTodoUseCase,
  }) : super(TodoInitial());

  Future<void> fetchTodos() async {
    value = TodoLoading();
    final result = await fetchTodosUseCase();

    final (failure, todos) = result;

    if (failure != null) {
      value = TodoError(failure.message);
    } else if (todos != null && todos.isEmpty) {
      value = TodoEmpty();
    } else {
      value = TodoLoaded(todos!);
    }
  }

  Future<void> createTodo(String title, {String? description}) async {
    if (title.isEmpty) {
      value = TodoError('O título é obrigatório.');
      return;
    }

    value = TodoLoading();
    final failure = await createTodoUseCase(title, description: description);

    if (failure != null) {
      value = TodoError(failure.message);
    } else {
      await fetchTodos();
    }
  }

  Future<void> updateTodo(TodoItemEntity todo) async {
    if (todo.title.isEmpty) {
      value = TodoError('O título é obrigatório.');
      return;
    }

    value = TodoLoading();
    final failure = await updateTodoUseCase(todo);

    if (failure != null) {
      value = TodoError(failure.message);
    } else {
      await fetchTodos();
    }
  }

  Future<void> deleteTodo(int todoId) async {
    value = TodoLoading();
    final failure = await deleteTodoUseCase(todoId);

    if (failure != null) {
      value = TodoError(failure.message);
    } else {
      await fetchTodos();
    }
  }
}
