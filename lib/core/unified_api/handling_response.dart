import '../error/exception.dart';

mixin HandlingResponse {
  Exception getException({required int statusCode, String? errorMessage}) {
    if (statusCode >= 400 && statusCode < 500) {
      return ApiException(message: errorMessage);
    } else {
      return ServerException(message: errorMessage);
    }
  }
}
