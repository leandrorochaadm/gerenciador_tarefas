class Failure {
  final String message;
  Failure(this.message);

  @override
  String toString() => 'Failure: $message';
}

class CreateFailure extends Failure {
  CreateFailure(String? message)
      : super(message ?? 'Falha ao criar o recurso.');
}

class DuplicateEntryFailure extends Failure {
  DuplicateEntryFailure(String? message)
      : super(message ?? 'O recurso já existe.');
}

class DataUnavailableFailure extends Failure {
  DataUnavailableFailure(String? message)
      : super(message ?? 'Os dados estão indisponíveis.');
}

class UnauthorizedFailure extends Failure {
  UnauthorizedFailure(String? message)
      : super(message ?? 'Acesso não autorizado.');
}

class UpdateFailure extends Failure {
  UpdateFailure(String? message)
      : super(message ?? 'Falha ao atualizar o recurso.');
}

class ConflictFailure extends Failure {
  ConflictFailure(String? message)
      : super(message ?? 'Conflito ao atualizar o recurso.');
}

class DeleteFailure extends Failure {
  DeleteFailure(String? message)
      : super(message ?? 'Falha ao excluir o recurso.');
}

class ResourceNotFoundFailure extends Failure {
  ResourceNotFoundFailure(String? message)
      : super(message ?? 'O recurso não foi encontrado.');
}

class ServerFailure extends Failure {
  ServerFailure(String? message)
      : super(message ?? 'O servidor não respondeu.');
}

class InvalidInputFailure extends Failure {
  InvalidInputFailure(String? message)
      : super(message ?? 'Os dados fornecidos são inválidos.');
}
