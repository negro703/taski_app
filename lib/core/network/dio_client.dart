import 'package:dio/dio.dart';

import '../utils/constants/app_constants.dart';

class DioClient {
  const DioClient({required this.instance});

  final Dio instance;

  static Dio createBaseDio() {
    return Dio(
      BaseOptions(
        baseUrl: AppConstants.externalApiBaseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),
        responseType: ResponseType.json,
        headers: const {
          Headers.acceptHeader: Headers.jsonContentType,
          Headers.contentTypeHeader: Headers.jsonContentType,
        },
      ),
    );
  }
}
