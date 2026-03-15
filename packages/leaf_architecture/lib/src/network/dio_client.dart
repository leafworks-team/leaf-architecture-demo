import 'package:dio/dio.dart';

import 'failures.dart';

class DioClient {
  late final Dio dio;

  DioClient({
    required String baseUrl,
    Map<String, dynamic>? headers,
    List<Interceptor>? interceptors,
  }) {
    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      headers: headers,
    ));

    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException error, ErrorInterceptorHandler handler) {
          Failure failure;
          switch (error.type) {
            case DioExceptionType.connectionTimeout:
            case DioExceptionType.sendTimeout:
            case DioExceptionType.receiveTimeout:
            case DioExceptionType.connectionError:
              failure = const Failure.network();
              break;
            case DioExceptionType.badResponse:
              failure = Failure.server(error.response?.statusMessage);
              break;
            default:
              failure = const Failure.cache();
          }
          handler.next(error.copyWith(error: failure));
        },
      ),
    );

    if (interceptors != null) {
      dio.interceptors.addAll(interceptors);
    }
  }
}
