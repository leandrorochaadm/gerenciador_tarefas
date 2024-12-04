import 'package:inicie/domain/repositories/todo_repository.dart';

import '../../data/exceptions/repository_exceptions.dart';
import '../entities/todo_item.dart';
import '../failures/failure.dart';

class FetchTodoListUseCase {
  final TodoRepository repository;

  FetchTodoListUseCase(this.repository);

  Future<(Failure?, List<TodoItemEntity>?)> call() async {
    try {
      final todoList = await repository.getTodos();

      return (null, todoList);
    } on DataUnavailableInRepositoryException {
      return (Failure('As tarefas não estão indisponíveis.'), null);
    } on EntityMappingRepositoryException {
      return (Failure('Falha ao mapear as informações da tarefa'), null);
    } on RepositoryException catch (_) {
      return (Failure('Falha na fonte de dados'), null);
    } catch (e) {
      return (Failure('Falha inesperado'), null);
    }
  }
}
