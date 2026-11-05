import 'package:leaf_architecture/network.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/network/dio_client.dart';
import '../models/photo_model.dart';

part 'photo_remote_data_source.g.dart';

@Riverpod(keepAlive: true)
PhotoRemoteDataSource photoRemoteDataSource(Ref ref) => PhotoRemoteDataSource(ref.watch(unsplashDioClientProvider).dio);

@RestApi()
abstract class PhotoRemoteDataSource {
  factory PhotoRemoteDataSource(Dio dio) = _PhotoRemoteDataSource;

  @GET('/photos')
  Future<List<PhotoModel>> getPhotos(@Query('page') int page, @Query('per_page') int perPage);
}
