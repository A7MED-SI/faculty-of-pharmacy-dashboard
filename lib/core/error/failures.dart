abstract class Failure {
  Failure(this.message);

  final String? message;
}

class ServerFailure extends Failure {
  ServerFailure({ String? message}) : super(message);
}

class TimeOutFailure extends Failure {
  TimeOutFailure({String? message}) : super(message);
}

class ApiFailure extends Failure {
  ApiFailure({String? message}) : super(message);
}
