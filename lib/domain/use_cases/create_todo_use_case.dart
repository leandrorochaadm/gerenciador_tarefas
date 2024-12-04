import '../../data/exceptions/repository_exceptions.dart';
import '../entities/todo_item.dart';
import '../failures/failure.dart';
import '../repositories/todo_repository.dart';

class CreateTodoUseCase {
  final TodoRepository repository;

  CreateTodoUseCase(this.repository);
  Future<Failure?> call(String title,
      {String? description, bool? isDone}) async {
    if (title.isEmpty) {
      return Failure('O título é obrigatório.');
    }

    try {
      final todo = TodoItemEntity(
        title: title,
        description: description,
        isDone: isDone,
      );

      await repository.postTodoItem(todo);
      return null;
    } on CreateRepositoryException {
      return (Failure('Não foi possivel criar a tarefa $title'));
    } on InvalidInputRepositoryException {
      return (Failure('Falha ao mapear as informações da tarefa'));
    } on RepositoryException catch (_) {
      return (Failure('Falha na fonte de dados'));
    } catch (e) {
      return (Failure('Falha inesperado'));
    }
  }
}
