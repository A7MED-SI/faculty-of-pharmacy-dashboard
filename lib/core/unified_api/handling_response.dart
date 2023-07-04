
import '../error/exception.dart';

mixin HandlingResponse {
  Exception getException(
      {required int statusCode}) {
    if (statusCode == 330) {
      return DataDuplicatesException();
    } else if (statusCode == 400 || statusCode == 422) {
      return MissingParamException();
    } else if (statusCode == 430) {
      return NotAuthenticatedException();
    } else if (statusCode == 460 || statusCode == 550) {
      return UserNotAllowedToAccessException();
    } else if (statusCode == 560) {
      return OperationFailedException();
    } else if (statusCode == 499) {
      return TokenMisMatchException();
    } else if (statusCode == 401) {
      return DataNotFoundException();
    } else if (statusCode == 522) {
      return InvalidEmailException();
    } else if (statusCode == 450) {
      return InvalidPhoneException();
    } else {
      return ServerException();
    }
  }
}
