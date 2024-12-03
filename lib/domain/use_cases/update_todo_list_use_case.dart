import '../entities/todo_item.dart';
import '../repositories/todo_repository.dart';

class UpdateTodoListUseCase {
  final TodoRepository repository;

  UpdateTodoListUseCase(this.repository);
  Future<String?> call(TodoItemEntity todoItem) async {
    try {
      await repository.putTodoItem(todoItem);
      return null;
    } catch (e) {
      return 'Não foi possivel atualizar o item';
    }
  }
}
