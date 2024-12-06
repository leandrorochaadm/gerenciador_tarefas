import 'package:flutter/foundation.dart';

import '../../domain/entities/todo_item.dart';
import '../../domain/failures/failure.dart';
import '../../domain/use_cases/create_todo_use_case.dart';
import '../../domain/use_cases/update_todo_use_case.dart';
import '../../domain/use_cases/validate_todo_form_use_case.dart';
import '../states/todo_form_state.dart';

class TodoFormController extends ValueNotifier<TodoFormState> {
  final ValidateTodoFormUseCase validateTodoFormUseCase;
  final CreateTodoUseCase createTodoUseCase;
  final UpdateTodoUseCase updateTodoUseCase;
  final TodoItemEntity? todoItem;

  /// Callback opcional para exibir mensagens na UI.
  void Function(String message)? onMessage;
  void Function()? onNavigatorBack;

  TodoFormController({
    this.todoItem,
    required this.createTodoUseCase,
    required this.updateTodoUseCase,
    required this.validateTodoFormUseCase,
  }) : super(
          TodoFormState(
            title: todoItem?.title ?? '',
            description: todoItem?.description ?? '',
            isDone: todoItem?.isDone ?? false,
          ),
        );

  bool get _isNewTodo => todoItem == null;

  String get appBarTitle => _isNewTodo ? 'Criar Nova Tarefa' : 'Editar Tarefa';

  String get buttonSubmitText => _isNewTodo ? 'Salvar' : 'Atualizar';

  void updateTitle(String title) {
    final titleError = validateTodoFormUseCase.validateTitle(title);
    value = value.copyWith(
      title: title,
      titleError: titleError,
    );
  }

  void updateDescription(String description) {
    final descriptionError =
        validateTodoFormUseCase.validateDescription(description);
    value = value.copyWith(
      description: description,
      descriptionError: descriptionError,
    );
  }

  Future<void> submit() async {
    if (!_validateForm()) return;

    Failure? failure;

    if (_isNewTodo) {
      failure = await createTodoUseCase(
        value.title,
        description: value.description,
      );
    } else {
      failure = await updateTodoUseCase(
        TodoItemEntity(
          id: todoItem!.id,
          title: value.title,
          description: value.description,
          isDone: value.isDone,
        ),
      );
    }

    if (failure != null) {
      onMessage?.call(failure.message);
      return;
    }

    final successMessage = _isNewTodo
        ? 'Tarefa criada com sucesso!'
        : 'Tarefa atualizada com sucesso!';

    onMessage?.call(successMessage);
    onNavigatorBack?.call();
  }

  bool _validateForm() {
    final currentState = value;

    final titleError =
        validateTodoFormUseCase.validateTitle(currentState.title);
    final descriptionError =
        validateTodoFormUseCase.validateDescription(currentState.description);

    if (titleError != null || descriptionError != null) {
      value = currentState.copyWith(
        titleError: titleError,
        descriptionError: descriptionError,
      );
      onMessage?.call('Por favor, verifique os campos.');
      return false;
    }
    return true;
  }
}
