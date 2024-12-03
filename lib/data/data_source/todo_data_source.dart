import '../models/todo_item_model.dart';

abstract class TodoDataSource {
  Future<List<TodoItemModel>> getTodoItemModels();
  Future<void> postTodoItemModel(TodoItemModel todoItemModel);
  Future<void> updateTodoItemModel(TodoItemModel todoItemModel);
  Future<void> deleteTodoItemModelById(int id);
}
