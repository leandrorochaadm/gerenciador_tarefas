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
  }) : super(TodoStateInitial()) {
    fetchTodos();
  }

  TodoItemEntity? _lastDeletedTodo; // Armazena a última tarefa excluída
  List<TodoItemEntity> _lastTodos = []; // Armazena a última lista de tarefas

  Future<void> fetchTodos() async {
    value = TodoStateLoading();
    final (failure, todos) = await fetchTodosUseCase();

    if (todos == null || todos.isEmpty) {
      _lastTodos = [];
      value = TodoStateEmpty();
      return;
    }

    if (failure != null) {
      value = TodoStateFail(_lastTodos, message: failure.message);
      return;
    }

    if (todos.isNotEmpty) {
      _lastTodos = todos;
      value = TodoStateLoaded(todos);
      return;
    }
  }

  Future<void> createTodo(String title,
      {String? description, bool? isDone}) async {
    if (title.isEmpty) {
      value = TodoStateFail(_lastTodos, message: 'O título é obrigatório.');
      return;
    }

    value = TodoStateLoading();
    final failure = await createTodoUseCase(title,
        description: description, isDone: isDone);

    if (failure != null) {
      value = TodoStateFail(_lastTodos, message: failure.message);
    } else {
      await fetchTodos();
    }
  }

  Future<void> updateTodo(TodoItemEntity todo) async {
    if (todo.title.isEmpty) {
      value = TodoStateFail(_lastTodos, message: 'O título é obrigatório.');
      return;
    }

    value = TodoStateLoading();
    final failure = await updateTodoUseCase(todo);

    if (failure != null) {
      value = TodoStateFail(_lastTodos, message: failure.message);
    } else {
      await fetchTodos();
    }
  }

  Future<void> deleteTodo(TodoItemEntity todo) async {
    _lastDeletedTodo = todo;

    value = TodoStateLoading();
    final failure = await deleteTodoUseCase(todo.id);

    if (failure != null) {
      value = TodoStateFail(_lastTodos, message: failure.message);
      return;
    }

    await fetchTodos();
  }

  Future<void> finishTodo(TodoItemEntity todo) async {
    _lastDeletedTodo = todo;

    value = TodoStateLoading();
    final failure = await deleteTodoUseCase(todo.id);

    if (failure != null) {
      value = TodoStateFail(_lastTodos,
          message: 'Não foi possível finalizar a tarefa ${todo.title}.');
      return;
    }

    await fetchTodos();

    value = TodoStateUndo(
      _lastTodos,
      message: 'Tarefa "${todo.title}" foi finalizada.',
    );
  }

  Future<void> restoreLastDeletedTodo() async {
    if (_lastDeletedTodo != null) {
      value = TodoStateLoading();
      final failure = await createTodoUseCase(
        _lastDeletedTodo!.title,
        id: _lastDeletedTodo!.id,
        description: _lastDeletedTodo!.description,
        isDone: _lastDeletedTodo!.isDone,
      );

      if (failure != null) {
        value = TodoStateFail(_lastTodos, message: failure.message);
        return;
      }

      if (failure == null) {
        _lastDeletedTodo = null;
        await fetchTodos();
        return;
      }
    }
  }
}
