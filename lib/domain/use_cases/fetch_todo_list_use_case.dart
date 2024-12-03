import 'package:inicie/domain/repositories/todo_repository.dart';

import '../entities/todo_item.dart';
import '../failures/failure.dart';

class FetchTodoListUseCase {
  final TodoRepository repository;

  FetchTodoListUseCase(this.repository);
  Future<(Failure?, List<TodoItemEntity>?)> call() async {
    try {
      final todoList = await repository.getTodos();
      if (todoList.isEmpty) {
        return (NotFoundFailure('Lista de tarefas vazia'), null);
      }
      return (null, todoList);
    } catch (_) {
      return (
        ServerFailure('Não foi possivel carregar a lista de tarefas'),
        null
      );
    }
  }
}
