import '../../data/exceptions/repository_exceptions.dart';
import '../failures/failure.dart';
import '../repositories/todo_repository.dart';

class DeleteTodoUseCase {
  final TodoRepository repository;

  DeleteTodoUseCase(this.repository);
  Future<Failure?> call(int todoItemId) async {
    if (todoItemId <= 0) {
      return (Failure('Informe o id da tarefa'));
    }

    try {
      await repository.deleteTodoItem(todoItemId);
      return null;
    } on InvalidInputRepositoryException {
      return (Failure('Parâmetros inválidos'));
    } on DeleteRepositoryException {
      return (Failure('Não foi possivel excluir a tarefa'));
    } on RepositoryException catch (_) {
      return (Failure('Falha na fonte de dados'));
    } catch (e) {
      return (Failure('Falha inesperado'));
    }
  }
}
