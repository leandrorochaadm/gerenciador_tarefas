import '../../data/exceptions/repository_exceptions.dart';
import '../entities/todo_item.dart';
import '../failures/failure.dart';
import '../repositories/todo_repository.dart';

class UpdateTodoUseCase {
  final TodoRepository repository;

  UpdateTodoUseCase(this.repository);
  Future<Failure?> call(TodoItemEntity todoItem) async {
    try {
      await repository.putTodoItem(todoItem);
      return null;
    } on InvalidInputRepositoryException {
      return (Failure('Parâmetros inválidos'));
    } on ResourceNotFoundInRepositoryException {
      return (Failure('Tarefa nao encontrada'));
    } on UpdateRepositoryException {
      return (Failure('Não foi possivel atualizar a tarefa'));
    } on RepositoryException catch (_) {
      return (Failure('Falha na fonte de dados'));
    } catch (e) {
      return (Failure('Falha inesperado'));
    }
  }
}
