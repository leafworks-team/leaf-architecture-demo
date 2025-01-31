import 'package:architecture_sample/data/datasources/PhotoRemoteDataSource.dart';
import 'package:architecture_sample/data/models/photo_model.dart';
import 'package:architecture_sample/domain/entities/photo_entity.dart';

import '../../domain/repositories/photo_repository.dart';

class PhotoRepositoryImpl extends PhotoRepository {
  final PhotoRemoteDataSource _dataSource;

  PhotoRepositoryImpl(this._dataSource);

  @override
  Future<List<PhotoEntity>> getPhotos(int page, int perPage) async {
    final result = await _dataSource.getPhotos(page, perPage);
    return result.map((json) => json.toEntity()).toList();
  }
}
