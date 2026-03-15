import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasources/PhotoRemoteDataSource.dart';
import '../../data/repositories/photo_repository_impl.dart';
import '../entities/photo_entity.dart';

part 'photo_repository.g.dart';

@riverpod
PhotoRepository photoRepository(Ref ref) =>
    PhotoRepositoryImpl(ref.watch(photoRemoteDataSourceProvider));

abstract class PhotoRepository {
  Future<List<PhotoEntity>> getPhotos(int page, int perPage);
}
