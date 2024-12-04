class RepositoryException implements Exception {
  final String message;

  RepositoryException(this.message);

  @override
  String toString() => 'RepositoryException: $message';
}

class CreateRepositoryException extends RepositoryException {
  CreateRepositoryException(String? message)
      : super(message ?? 'Failed to create the resource in the repository.');
}

class DuplicateEntryInRepositoryException extends RepositoryException {
  DuplicateEntryInRepositoryException(String? message)
      : super(message ?? 'The resource already exists in the repository.');
}

class DataUnavailableInRepositoryException extends RepositoryException {
  DataUnavailableInRepositoryException(String? message)
      : super(message ?? 'The data is unavailable in the repository.');
}

class UpdateRepositoryException extends RepositoryException {
  UpdateRepositoryException(String? message)
      : super(message ?? 'Failed to update the resource in the repository.');
}

class ConflictRepositoryException extends RepositoryException {
  ConflictRepositoryException(String? message)
      : super(message ??
            'Conflict occurred while updating the resource in the repository.');
}

class DeleteRepositoryException extends RepositoryException {
  DeleteRepositoryException(String? message)
      : super(message ?? 'Failed to delete the resource from the repository.');
}

class ResourceNotFoundInRepositoryException extends RepositoryException {
  ResourceNotFoundInRepositoryException(String? message)
      : super(message ?? 'The resource was not found in the repository.');
}

class ServerRepositoryException extends RepositoryException {
  ServerRepositoryException(String? message)
      : super(message ?? 'The server did not respond.');
}

class InvalidInputRepositoryException extends RepositoryException {
  InvalidInputRepositoryException(String? message)
      : super(message ?? 'The provided data is invalid in the repository.');
}

class EntityMappingRepositoryException extends RepositoryException {
  EntityMappingRepositoryException(String? message)
      : super(message ?? 'Entity mapping');
}
