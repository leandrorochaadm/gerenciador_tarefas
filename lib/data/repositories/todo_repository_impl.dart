import '../../domain/entities/todo_item.dart';
import '../../domain/repositories/todo_repository.dart';
import '../data_source/todo_data_source.dart';
import '../exceptions/repository_exceptions.dart';
import '../models/todo_item_model.dart';

class TodoRepositoryImpl implements TodoRepository {
  TodoDataSource todoDataSource;

  TodoRepositoryImpl(this.todoDataSource);

  @override
  Future<List<TodoItemEntity>> getTodos() async {
    try {
      final models = await todoDataSource.getTodoItemModels();

      final todoItemModels = models
          .map<TodoItemEntity>(
              (todoItemModel) => TodoItemEntity.fromModel(todoItemModel))
          .toList();

      return todoItemModels;
    } on RepositoryException catch (_) {
      // Log ou tratamento específico para erro de leitura
      rethrow;
    } catch (e) {
      // Tratamento genérico para erros inesperados
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<void> postTodoItem(TodoItemEntity entity) async {
    try {
      final model = TodoItemModel.fromEntity(entity);
      await todoDataSource.postTodoItemModel(model);
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  //--------------

  @override
  Future<void> deleteTodoItem(int todoItemId) async {
    try {
      await todoDataSource.deleteTodoItemModelById(todoItemId);
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<void> putTodoItem(TodoItemEntity todoItemEntity) async {
    try {
      final todoItemModel = TodoItemModel.fromEntity(todoItemEntity);
      await todoDataSource.postTodoItemModel(todoItemModel);
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }
}
