class Result<T> {
  final T? data;
  final String? message;
  final bool isSuccess;

  Result._({this.data, this.message, required this.isSuccess});

  factory Result.success(T data, [String? message]) {
    return Result._(data: data, message: message, isSuccess: true);
  }

  factory Result.failure(String message) {
    return Result._(message: message, isSuccess: false);
  }

  bool get isFailure => !isSuccess;

  @override
  String toString() {
    return 'Result(isSuccess: $isSuccess, message: $message, data: $data)';
  }
}
