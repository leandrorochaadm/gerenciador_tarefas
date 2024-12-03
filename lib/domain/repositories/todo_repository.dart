import '../entities/todo_item.dart';

abstract class TodoRepository {
  Future<List<TodoItemEntity>> getTodoList();

  Future<void> postTodoItem(TodoItemEntity todoItem);

  Future<void> putTodoItem(TodoItemEntity todoItem);

  Future<void> deleteTodoItem(int todoItemId);
}
