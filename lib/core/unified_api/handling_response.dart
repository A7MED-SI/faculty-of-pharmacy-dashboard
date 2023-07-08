import '../error/exception.dart';

mixin HandlingResponse {
  Exception getException({required int statusCode}) {
    if (statusCode >= 400 && statusCode < 500) {
      return ApiException();
    } else {
      return ServerException();
    }
  }
}
