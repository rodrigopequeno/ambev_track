import 'package:equatable/equatable.dart';

class ResponseService<T> extends Equatable {
  final T? data;
  final Map<String, dynamic> requestOptions;
  final Map<String, dynamic>? headers;
  final int? statusCode;
  final String? statusMessage;

  const ResponseService({
    required this.requestOptions,
    this.data,
    this.headers,
    this.statusCode,
    this.statusMessage,
  });

  @override
  List<Object?> get props => [
        requestOptions,
        data,
        headers,
        statusCode,
        statusMessage,
      ];
}
