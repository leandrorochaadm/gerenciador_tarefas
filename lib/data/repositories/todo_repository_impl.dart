import '../../domain/entities/todo_item.dart';
import '../../domain/repositories/todo_repository.dart';
import '../data_source/todo_data_source.dart';
import '../exceptions/data_source_exceptions.dart';
import '../exceptions/repository_exceptions.dart';
import '../models/todo_item_model.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoDataSource todoDataSource;

  TodoRepositoryImpl(this.todoDataSource);

  @override
  Future<List<TodoItemEntity>> getTodos() async {
    try {
      final models = await todoDataSource.getTodoItemModels();

      final todoItemEntities = models.map<TodoItemEntity>((todoItemModel) {
        if (todoItemModel.id == 0) {
          throw EntityMappingRepositoryException(
              'ID is null for TodoItemModel: ${todoItemModel.title}');
        }
        return TodoItemEntity.fromModel(todoItemModel);
      }).toList();

      return todoItemEntities;
    } on DataParsingDataSourceException catch (e) {
      throw DataUnavailableInRepositoryException(
          'Failed to parse data: ${e.message}');
    } on InvalidDataFormatDataSourceException catch (e) {
      throw RepositoryException('Cache error: ${e.message}');
    } on DataSourceException catch (e) {
      throw RepositoryException(e.message);
    } catch (e) {
      throw RepositoryException('Unexpected error while fetching todos: $e');
    }
  }

  @override
  Future<void> postTodoItem(TodoItemEntity todoItemEntity) async {
    try {
      TodoItemModel todoItemModel;

      try {
        todoItemModel = TodoItemModel.fromEntity(todoItemEntity);
      } catch (e) {
        throw InvalidInputRepositoryException(
            'Failed to convert TodoItemEntity to TodoItemModel: $e');
      }
      await todoDataSource.postTodoItemModel(todoItemModel);
    } on WriteDataSourceException {
      throw CreateRepositoryException('The todo item already exists.');
    } on DataSourceException catch (e) {
      throw RepositoryException('Cache error: ${e.message}');
    } catch (e) {
      throw RepositoryException(
          'Unexpected error while creating todo item: $e');
    }
  }

  @override
  Future<void> deleteTodoItem(int todoItemId) async {
    if (todoItemId <= 0) {
      throw InvalidInputRepositoryException(
          'The todo item id must be greater than 0.');
    }
    try {
      await todoDataSource.deleteTodoItemModelById(todoItemId);
    } on ResourceNotFoundInDataSourceException {
      throw RepositoryException(
          'The todo item with id $todoItemId was not found.');
    } on DataSourceException catch (e) {
      throw DeleteRepositoryException(e.message);
    } catch (e) {
      throw RepositoryException(
          'Unexpected error while deleting todo item: $e');
    }
  }

  @override
  Future<void> putTodoItem(TodoItemEntity todoItemEntity) async {
    try {
      TodoItemModel todoItemModel;

      try {
        todoItemModel = TodoItemModel.fromEntity(todoItemEntity);
      } catch (e) {
        throw InvalidInputRepositoryException(
            'Failed to convert TodoItemEntity to TodoItemModel: $e');
      }

      await todoDataSource.updateTodoItemModel(todoItemModel);
    } on ResourceNotFoundInDataSourceException {
      throw ResourceNotFoundInRepositoryException(
          'The todo item with id ${todoItemEntity.id} was not found.');
    } on WriteDataSourceException catch (e) {
      throw UpdateRepositoryException(e.message);
    } on DataSourceException catch (e) {
      throw RepositoryException('Invalid input: ${e.message}');
    } catch (e) {
      throw RepositoryException(
          'Unexpected error while updating todo item: $e');
    }
  }
}
