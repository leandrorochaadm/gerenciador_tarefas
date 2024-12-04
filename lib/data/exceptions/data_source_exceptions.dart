class DataSourceException implements Exception {
  final String message;

  DataSourceException(this.message);

  @override
  String toString() => 'DataSourceException: $message';
}

class DataParsingDataSourceException extends DataSourceException {
  DataParsingDataSourceException(String message)
      : super('Data parsing error in Data Source: $message');
}

class InvalidDataFormatDataSourceException extends DataSourceException {
  InvalidDataFormatDataSourceException(String message)
      : super('Invalid data format in Data Source: $message');
}

class DataUnavailableInDataSourceException extends DataSourceException {
  DataUnavailableInDataSourceException()
      : super('Data is unavailable in the data source.');
}

class CacheDataSourceException extends DataSourceException {
  CacheDataSourceException(String message)
      : super('Cache error in Data Source: $message');
}

class WriteDataSourceException extends CacheDataSourceException {
  WriteDataSourceException(String message)
      : super('Failed to write data to cache in Data Source: $message');
}

class CacheReadDataSourceException extends CacheDataSourceException {
  CacheReadDataSourceException(String message)
      : super('Failed to read data from cache in Data Source: $message');
}

class ResourceNotFoundInDataSourceException extends DataSourceException {
  ResourceNotFoundInDataSourceException(String message)
      : super('Resource not found in Data Source: $message');
}

class DuplicateModelInDataSourceException extends DataSourceException {
  DuplicateModelInDataSourceException(String message)
      : super('Duplicate model in Data Source: $message');
}

class ServerDataSourceException extends DataSourceException {
  ServerDataSourceException(String message)
      : super('Server error in Data Source: $message');
}
