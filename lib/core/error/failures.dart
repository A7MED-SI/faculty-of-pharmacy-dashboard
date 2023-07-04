abstract class Failure {
  Failure(this.message);

  final String? message;
}

class ServerFailure extends Failure {
  ServerFailure({ String? message}) : super(message);
}

class CacheFailure extends Failure {
  CacheFailure({String? message}) : super(message);
}

class DataDuplicatesFailure extends Failure {
  DataDuplicatesFailure({String? message}) : super(message);
}

class MissingParamFailure extends Failure {
  MissingParamFailure({String? message}) : super(message);
}

class UserNotAllowedToAccessFailure extends Failure {
  UserNotAllowedToAccessFailure({String? message}) : super(message);
}

class OperationFailedFailure extends Failure {
  OperationFailedFailure({String? message}) : super(message);
}

class TokenMisMatchFailure extends Failure {
  TokenMisMatchFailure({String? message}) : super(message);
}

class DataNotFoundFailure extends Failure {
  DataNotFoundFailure({String? message}) : super(message);
}

class InvalidEmailFailure extends Failure {
  InvalidEmailFailure({String? message}) : super(message);
}

class InvalidPhoneFailure extends Failure {
  InvalidPhoneFailure({String? message}) : super(message);
}

class TimeOutFailure extends Failure {
  TimeOutFailure({String? message}) : super(message);
}

class NotAuthenticatedFailure extends Failure {
  NotAuthenticatedFailure({String? message}) : super(message);
}

class ApiFailure extends Failure {
  ApiFailure({String? message}) : super(message);
}
