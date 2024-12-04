import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../exceptions/data_source_exceptions.dart';
import '../models/todo_item_model.dart';
import 'todo_data_source.dart';

const _todoItemKey = 'TodoItems';

class TodoDataTodoDataSource extends TodoDataSource {
  final SharedPreferences sharedPreferences;

  TodoDataTodoDataSource(this.sharedPreferences);

  @override
  Future<List<TodoItemModel>> getTodoItemModels() async {
    try {
      final jsonString = sharedPreferences.getString(_todoItemKey);
      if (jsonString != null) {
        final List decodedList = jsonDecode(jsonString);
        return decodedList.map((json) {
          try {
            return TodoItemModel.fromJson(json);
          } catch (e) {
            throw DataParsingDataSourceException('Error parsing Todo item: $e');
          }
        }).toList();
      }
      return [];
    } on FormatException catch (e) {
      throw InvalidDataFormatDataSourceException(e.toString());
    } catch (e) {
      throw DataSourceException('Unexpected error while fetching todos: $e');
    }
  }

  @override
  Future<void> postTodoItemModel(TodoItemModel todoItemModel) async {
    try {
      final todoItemModels = await getTodoItemModels();
      todoItemModels.add(todoItemModel);
      final isSaved = await sharedPreferences.setString(
        _todoItemKey,
        jsonEncode(todoItemModels.map((e) => e.toJson()).toList()),
      );
      if (!isSaved) {
        throw WriteDataSourceException('Failed to save the new todo item.');
      }
    } catch (e) {
      throw DataSourceException(
          'Unexpected error while saving a todo item: $e');
    }
  }

  @override
  Future<void> updateTodoItemModel(TodoItemModel todoItemModel) async {
    try {
      final todoItemModels = await getTodoItemModels();
      final index = todoItemModels.indexWhere((t) => t.id == todoItemModel.id);
      if (index != -1) {
        todoItemModels[index] = todoItemModel;
        final isSaved = await sharedPreferences.setString(
          _todoItemKey,
          jsonEncode(todoItemModels.map((e) => e.toJson()).toList()),
        );
        if (!isSaved) {
          throw WriteDataSourceException('Failed to update the todo item.');
        }
      } else {
        throw ResourceNotFoundInDataSourceException(
            'The todo item with id ${todoItemModel.id} was not found.');
      }
    } catch (e) {
      throw DataSourceException(
          'Unexpected error while updating a todo item: $e');
    }
  }

  @override
  Future<void> deleteTodoItemModelById(int id) async {
    try {
      final todoItemModels = await getTodoItemModels();
      final initialLength = todoItemModels.length;

      todoItemModels.removeWhere((t) => t.id == id);

      if (todoItemModels.length == initialLength) {
        throw ResourceNotFoundInDataSourceException(
            'The todo item with id $id was not found.');
      }

      final isSaved = await sharedPreferences.setString(
        _todoItemKey,
        jsonEncode(todoItemModels.map((e) => e.toJson()).toList()),
      );
      if (!isSaved) {
        throw WriteDataSourceException('Failed to delete the todo item.');
      }
    } catch (e) {
      throw DataSourceException(
          'Unexpected error while deleting a todo item: $e');
    }
  }
}
