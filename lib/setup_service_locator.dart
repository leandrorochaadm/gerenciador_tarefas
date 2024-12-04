import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/data_source/shared_preferences_todo_data_source.dart';
import 'data/repositories/todo_repository_impl.dart';
import 'domain/use_cases/create_todo_use_case.dart';
import 'domain/use_cases/delete_todo_use_case.dart';
import 'domain/use_cases/fetch_todos_use_case.dart';
import 'domain/use_cases/update_todo_use_case.dart';
import 'presentation/controllers/todo_controller.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // Data Source
  getIt.registerFactory(
      () => TodoDataTodoDataSource(getIt<SharedPreferences>()));

  // Repository
  getIt.registerFactory(
      () => TodoRepositoryImpl(getIt<TodoDataTodoDataSource>()));

  // Use Cases
  getIt.registerFactory(() => FetchTodosUseCase(getIt<TodoRepositoryImpl>()));
  getIt.registerFactory(() => CreateTodoUseCase(getIt<TodoRepositoryImpl>()));
  getIt.registerFactory(() => UpdateTodoUseCase(getIt<TodoRepositoryImpl>()));
  getIt.registerFactory(() => DeleteTodoUseCase(getIt<TodoRepositoryImpl>()));

  // Controller
  getIt.registerFactory(() => TodoController(
        fetchTodosUseCase: getIt<FetchTodosUseCase>(),
        createTodoUseCase: getIt<CreateTodoUseCase>(),
        updateTodoUseCase: getIt<UpdateTodoUseCase>(),
        deleteTodoUseCase: getIt<DeleteTodoUseCase>(),
      ));
}
