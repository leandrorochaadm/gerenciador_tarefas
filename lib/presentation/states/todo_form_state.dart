class TodoFormState {
  final String title;
  final String? titleError;
  final String description;
  final String? descriptionError;
  final bool isDone;
  final String? formErrorMessage;

  TodoFormState({
    this.title = '',
    this.titleError,
    this.description = '',
    this.descriptionError,
    this.isDone = false,
    this.formErrorMessage,
  });

  TodoFormState copyWith({
    String? title,
    String? titleError,
    String? description,
    String? descriptionError,
    bool? isDone,
    String? formErrorMessage,
  }) {
    return TodoFormState(
      title: title ?? this.title,
      titleError: titleError ?? this.titleError,
      description: description ?? this.description,
      descriptionError: descriptionError ?? this.descriptionError,
      isDone: isDone ?? this.isDone,
      formErrorMessage: formErrorMessage ?? this.formErrorMessage,
    );
  }
}
