import 'package:flutter/foundation.dart';
import 'package:inicie/domain/use_cases/create_todo_use_case.dart';

import '../../domain/entities/todo_item.dart';
import '../../domain/failures/failure.dart';
import '../../domain/use_cases/update_todo_use_case.dart';
import '../../domain/use_cases/validate_todo_form_use_case.dart';
import '../states/todo_form_state.dart';

class TodoFormController extends ValueNotifier<TodoFormState> {
  final ValidateTodoFormUseCase validateTodoFormUseCase;
  final TodoItemEntity? todoItem;
  final CreateTodoUseCase createTodoUseCase;
  final UpdateTodoUseCase updateTodoUseCase;

  TodoFormController({
    this.todoItem,
    required this.createTodoUseCase,
    required this.updateTodoUseCase,
    required this.validateTodoFormUseCase,
  }) : super(TodoFormState()) {
    setInitialValues();
  }
  bool get _isNewTodoForm => todoItem == null;
  String get appBarTitle =>
      _isNewTodoForm ? 'Criar Nova Tarefa' : 'Editar Tarefa';
  String get buttonSubmitText => _isNewTodoForm ? 'Salvar' : 'Atualizar';

  bool get isFormValid =>
      value.titleError == null &&
      value.descriptionError == null &&
      value.formErrorMessage == null;

  void setInitialValues() {
    value = TodoFormState(
      title: todoItem?.title ?? '',
      description: todoItem?.description ?? '',
      isDone: todoItem?.isDone ?? false,
    );
  }

  void updateTitle(String title) {
    final titleError = validateTodoFormUseCase.validateTitle(title);
    value = value.copyWith(title: title, titleError: titleError);
  }

  void updateDescription(String description) {
    final descriptionError =
        validateTodoFormUseCase.validateDescription(description);
    value = value.copyWith(
        description: description, descriptionError: descriptionError);
  }

  void toggleIsDone(bool isDone) {
    value = value.copyWith(isDone: isDone);
  }

  bool validateForm() {
    final titleError = validateTodoFormUseCase.validateTitle(value.title);
    final descriptionError =
        validateTodoFormUseCase.validateDescription(value.description);

    value = value.copyWith(
      titleError: titleError,
      descriptionError: descriptionError,
    );

    return titleError == null && descriptionError == null;
  }

  void resetForm() {
    value = TodoFormState();
  }

  Future<void> submit() async {
    if (validateForm()) {
      Failure? failure;
      if (_isNewTodoForm) {
        failure = await createTodoUseCase(
          value.title,
          description: value.description,
        );
      } else {
        failure = await updateTodoUseCase(TodoItemEntity(
          id: todoItem!.id,
          title: value.title,
          description: value.description,
          isDone: value.isDone,
        ));
      }

      if (failure != null) {
        value = value.copyWith(formErrorMessage: failure.message);
      }
    }
  }
}
