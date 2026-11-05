import 'package:leaf_architecture/leaf_architecture.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../config/app_config.dart';

part 'dio_client.g.dart';

/// The Unsplash API. Add one provider per server: base URL, authentication and timeouts differ between servers.
@Riverpod(keepAlive: true)
DioClient unsplashDioClient(Ref ref) {
  final config = ref.watch(appConfigProvider);
  final client = DioClient(baseUrl: config.baseUrl, headers: {'Authorization': 'Client-ID ${config.accessKey}'});
  client.dio.options
    ..connectTimeout = const Duration(seconds: 10)
    ..receiveTimeout = const Duration(seconds: 30);
  return client;
}
