import '../entities/todo_item.dart';
import '../repositories/todo_repository.dart';

class CreateTodoUseCase {
  final TodoRepository repository;

  CreateTodoUseCase(this.repository);
  Future<String?> call(TodoItemEntity todoItem) async {
    try {
      await repository.postTodoItem(todoItem);
      return null;
    } catch (e) {
      return 'Não foi possivel criar a tarefa';
    }
  }
}
