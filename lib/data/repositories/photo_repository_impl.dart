import 'package:architecture_sample/data/datasources/photo_remote_data_source.dart';
import 'package:architecture_sample/data/models/photo_model.dart';
import 'package:architecture_sample/domain/entities/photo_entity.dart';
import 'package:architecture_sample/domain/repositories/photo_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'photo_repository_impl.g.dart';

@riverpod
PhotoRepository photoRepository(Ref ref) =>
    PhotoRepositoryImpl(ref.watch(photoRemoteDataSourceProvider));

class PhotoRepositoryImpl extends PhotoRepository {
  final PhotoRemoteDataSource _dataSource;

  PhotoRepositoryImpl(this._dataSource);

  @override
  Future<List<PhotoEntity>> getPhotos(int page, int perPage) async {
    final result = await _dataSource.getPhotos(page, perPage);
    return result.map((json) => json.toEntity()).toList();
  }
}
