class ValidateTodoFormUseCase {
  String? validateTitle(String title) {
    title = title.trim();
    if (title.isEmpty) return 'O título é obrigatório.';
    if (title.length < 5) return 'O título deve ter pelo menos 5 caracteres.';
    if (title.length > 50) return 'O título não pode exceder 50 caracteres.';
    return null;
  }

  String? validateDescription(String description) {
    if (description.length > 200) {
      return 'A descrição não pode exceder 200 caracteres.';
    }
    return null;
  }
}
