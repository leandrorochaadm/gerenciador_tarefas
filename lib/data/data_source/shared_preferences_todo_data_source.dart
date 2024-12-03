import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

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
        return decodedList.map((json) => TodoItemModel.fromJson(json)).toList();
      }
      return [];
    } on FormatException catch (e) {
      throw Exception('Failed to decode data: $e');
    } catch (e) {
      throw Exception('Unexpected error: $e');
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
        throw Exception('Failed to save data.');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<void> updateTodoItemModel(TodoItemModel todoItemModel) async {
    try {
      final todoItemModels = await getTodoItemModels();
      final index = todoItemModels.indexWhere((t) => t.id == todoItemModel.id);
      if (index != -1) {
        todoItemModels[index] = todoItemModel;
        await sharedPreferences.setString(_todoItemKey,
            jsonEncode(todoItemModels.map((e) => e.toJson()).toList()));
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<void> deleteTodoItemModelById(int id) async {
    try {
      final todoItemModels = await getTodoItemModels();
      todoItemModels.removeWhere((t) => t.id == id);
      await sharedPreferences.setString(_todoItemKey,
          jsonEncode(todoItemModels.map((e) => e.toJson()).toList()));
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
