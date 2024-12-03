import '../repositories/todo_repository.dart';

class DeleteTodoListUseCase {
  final TodoRepository repository;

  DeleteTodoListUseCase(this.repository);
  Future<String?> call(int todoItemId) async {
    try {
      await repository.deleteTodoItem(todoItemId);
      return null;
    } catch (e) {
      return 'Não foi possivel excluir a tarefa';
    }
  }
}
