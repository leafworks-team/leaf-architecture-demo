import 'package:architecture_sample/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';

import 'failures.dart';

@singleton
class DioClient {
  late final Dio dio;

  DioClient() {
    dio = Dio(BaseOptions(
        baseUrl: AppConstants.baseURL,
        headers: {'Authorization': 'Client-ID ${AppConstants.accessKey}'}));

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
  }
}

final dioClientProvider = Provider((ref) => DioClient());
