class TodoFormState {
  final String title;
  final String? titleError;
  final String description;
  final String? descriptionError;
  final bool isDone;

  TodoFormState({
    this.title = '',
    this.titleError,
    this.description = '',
    this.descriptionError,
    this.isDone = false,
  });

  TodoFormState copyWith({
    String? title,
    String? titleError,
    String? description,
    String? descriptionError,
    bool? isDone,
  }) {
    return TodoFormState(
      title: title ?? this.title,
      titleError: titleError,
      description: description ?? this.description,
      descriptionError: descriptionError,
      isDone: isDone ?? this.isDone,
    );
  }
}
