class RepositoryException implements Exception {
  final String message;
  RepositoryException(this.message);

  @override
  String toString() => 'RepositoryException: $message';
}

class DataNotFoundException extends RepositoryException {
  DataNotFoundException(super.message);
}

class ServerException extends RepositoryException {
  ServerException(super.message);
}

class CacheException extends RepositoryException {
  CacheException(super.message);
}

class InvalidDataException extends RepositoryException {
  InvalidDataException(super.message);
}

class NoConnectionException extends RepositoryException {
  NoConnectionException(super.message);
}
