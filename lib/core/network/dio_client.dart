import 'package:architecture_sample/constants.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@singleton
class DioClient {
  late final Dio dio;

  DioClient() {
    dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseURL,
      headers: {
        'Authorization': 'Client-ID ${AppConstants.accessKey}'
      }
    ));
  }
}