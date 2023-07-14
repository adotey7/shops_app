class HttpException implements Exception {
  HttpException(this.message);
  final String message;

  @override
  String toString() {
    // TODO: implement toString
    return message;
  }
}
