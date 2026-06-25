import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class ApiInterceptors extends Interceptor {
  ApiInterceptors(this._logger);

  final Logger _logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.i('${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _logger.d(
      '${response.statusCode} ${response.requestOptions.method} '
      '${response.requestOptions.uri}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.e(
      'API error: ${err.requestOptions.method} ${err.requestOptions.uri}',
      error: err,
      stackTrace: err.stackTrace,
    );
    handler.next(err);
  }
}