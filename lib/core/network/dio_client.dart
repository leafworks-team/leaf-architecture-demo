import 'package:architecture_sample/constants.dart';
import 'package:leaf_architecture/leaf_architecture.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_client.g.dart';

@riverpod
DioClient dioClient(Ref ref) => DioClient(
      baseUrl: AppConstants.baseURL,
      headers: {'Authorization': 'Client-ID ${AppConstants.accessKey}'},
    );
