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
  }) : super(TodoInitial()) {
    fetchTodos();
  }

  TodoItemEntity? _lastDeletedTodo; // Armazena a última tarefa excluída

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

  Future<void> createTodo(String title,
      {String? description, bool? isDone}) async {
    if (title.isEmpty) {
      value = TodoError('O título é obrigatório.');
      return;
    }

    value = TodoLoading();
    final failure = await createTodoUseCase(title,
        description: description, isDone: isDone);

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

  Future<void> deleteTodo(TodoItemEntity todo) async {
    _lastDeletedTodo = todo;
    value = TodoLoading();
    final failure = await deleteTodoUseCase(todo.id);

    if (failure != null) {
      value = TodoError(failure.message);
    } else {
      await fetchTodos();
    }
  }

  Future<void> restoreLastDeletedTodo() async {
    if (_lastDeletedTodo != null) {
      value = TodoLoading();
      final failure = await createTodoUseCase(
        _lastDeletedTodo!.title,
        description: _lastDeletedTodo!.description,
        isDone: _lastDeletedTodo!.isDone,
      );

      if (failure != null) {
        value = TodoError(failure.message);
      } else {
        _lastDeletedTodo = null;
        await fetchTodos();
      }
    }
  }
}
