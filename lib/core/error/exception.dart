class ServerException implements Exception {
  ServerException({this.message});

  final String? message;
}

class ApiException implements Exception {
  ApiException({this.message});
  
  final String? message;

}
