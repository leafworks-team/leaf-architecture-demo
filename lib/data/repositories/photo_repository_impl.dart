import 'package:leaf_architecture/network.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/photo_entity.dart';
import '../../domain/entities/photo_failure.dart';
import '../../domain/repositories/photo_repository.dart';
import '../datasources/photo_remote_data_source.dart';
import '../models/photo_model.dart';

part 'photo_repository_impl.g.dart';

@riverpod
PhotoRepository photoRepository(Ref ref) => PhotoRepositoryImpl(ref.watch(photoRemoteDataSourceProvider));

class PhotoRepositoryImpl implements PhotoRepository {
  PhotoRepositoryImpl(this._dataSource);

  final PhotoRemoteDataSource _dataSource;

  @override
  Future<List<PhotoEntity>> getPhotos(int page, int perPage) async {
    try {
      final models = await _dataSource.getPhotos(page, perPage);
      return models.map((model) => model.toEntity()).toList();
    } on DioException catch (error) {
      // DioClient's interceptor has already turned the error into a leaf_architecture Failure.
      throw PhotoFailure(switch (error.error) {
        NetworkFailure() => PhotoFailureKind.network,
        ServerFailure() => PhotoFailureKind.server,
        _ => PhotoFailureKind.unknown,
      });
    }
  }
}
