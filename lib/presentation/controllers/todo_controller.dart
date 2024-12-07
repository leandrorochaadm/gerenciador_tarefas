import 'package:flutter/material.dart';

import '../../domain/entities/todo_item.dart';
import '../../domain/use_cases/create_todo_use_case.dart';
import '../../domain/use_cases/delete_todo_use_case.dart';
import '../../domain/use_cases/fetch_todos_use_case.dart';
import '../../domain/use_cases/update_todo_use_case.dart';
import '../states/todo_state.dart';
import '../utils/type_message_enum.dart';

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

  /// Callback para exibir mensagens na UI.
  void Function(String message, TypeMessage type)? onMessage;

  Future<void> fetchTodos() async {
    value = TodoStateLoading();
    final (failure, todos) = await fetchTodosUseCase();

    if (todos == null || todos.isEmpty) {
      value = TodoStateEmpty();
      return;
    }

    if (failure != null) {
      onMessage?.call(failure.message, TypeMessage.fail);
      return;
    }

    if (todos.isNotEmpty) {
      value = TodoStateLoaded(todos);
      return;
    }
  }

  Future<void> createTodo(String title,
      {String? description, bool? isDone}) async {
    if (title.isEmpty) {
      onMessage?.call('O título é obrigatório.', TypeMessage.fail);
      return;
    }

    value = TodoStateLoading();
    final failure = await createTodoUseCase(title,
        description: description, isDone: isDone);

    if (failure != null) {
      onMessage?.call(failure.message, TypeMessage.fail);
    } else {
      await fetchTodos();
    }
  }

  Future<void> updateTodo(TodoItemEntity todo) async {
    if (todo.title.isEmpty) {
      onMessage?.call('O título é obrigatório.', TypeMessage.fail);
      return;
    }

    value = TodoStateLoading();
    final failure = await updateTodoUseCase(todo);

    if (failure != null) {
      onMessage?.call(failure.message, TypeMessage.fail);
    } else {
      onMessage?.call(
          'Tarefa "${todo.title}" foi atualizada.', TypeMessage.success);
      await fetchTodos();
    }
  }

  Future<void> deleteTodo(TodoItemEntity todo) async {
    _lastDeletedTodo = todo;

    value = TodoStateLoading();
    final failure = await deleteTodoUseCase(todo.id);

    if (failure != null) {
      onMessage?.call(failure.message, TypeMessage.fail);
      return;
    }

    onMessage?.call(
        'Tarefa "${todo.title}" foi excluida.', TypeMessage.success);

    await fetchTodos();
  }

  Future<void> finishTodo(TodoItemEntity todo) async {
    _lastDeletedTodo = todo;

    value = TodoStateLoading();
    final failure = await deleteTodoUseCase(todo.id);

    if (failure != null) {
      onMessage?.call('Não foi possível finalizar a tarefa ${todo.title}.',
          TypeMessage.fail);
      return;
    }

    onMessage?.call('Tarefa "${todo.title}" foi finalizada.', TypeMessage.undo);

    await fetchTodos();
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
        onMessage?.call(failure.message, TypeMessage.fail);
        return;
      }

      if (failure == null) {
        onMessage?.call(
          'Tarefa "${_lastDeletedTodo!.title}" foi restaurada.',
          TypeMessage.success,
        );
        _lastDeletedTodo = null;
        await fetchTodos();
        return;
      }
    }
  }
}
