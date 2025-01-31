import 'package:architecture_sample/core/network/dio_client.dart';
import 'package:architecture_sample/data/models/photo_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final photoRemoteDataSourceProvider =
    Provider((ref) => PhotoRemoteDataSource(ref.watch(dioClientProvider)));

class PhotoRemoteDataSource {
  final DioClient _dioClient;

  PhotoRemoteDataSource(this._dioClient);

  Future<List<PhotoModel>> getPhotos(int page, int perPage) async {
    final response = await _dioClient.dio.get(
      '/photos',
      queryParameters: {'page': page, 'per_page': perPage},
    );
    return (response.data as List)
        .map((json) => PhotoModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
