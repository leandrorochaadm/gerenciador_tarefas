import 'package:inicie/domain/repositories/todo_repository.dart';

import '../entities/todo_item.dart';

class FetchTodoListUseCase {
  final TodoRepository repository;

  FetchTodoListUseCase(this.repository);
  Future<(String?, List<TodoItemEntity>)> call() async {
    try {
      final todoList = await repository.getTodoList();
      return (null, todoList);
    } catch (e) {
      return (
        'Não foi possivel carregar a lista de tarefas',
        <TodoItemEntity>[]
      );
    }
  }
}
