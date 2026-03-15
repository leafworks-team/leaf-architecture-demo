import 'package:architecture_sample/core/network/dio_client.dart';
import 'package:architecture_sample/data/models/photo_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'photo_remote_data_source.g.dart';

@riverpod
PhotoRemoteDataSource photoRemoteDataSource(Ref ref) =>
    PhotoRemoteDataSource(ref.watch(dioClientProvider).dio);

@RestApi()
abstract class PhotoRemoteDataSource {
  factory PhotoRemoteDataSource(Dio dio) = _PhotoRemoteDataSource;

  @GET('/photos')
  Future<List<PhotoModel>> getPhotos(
    @Query('page') int page,
    @Query('per_page') int perPage,
  );
}
