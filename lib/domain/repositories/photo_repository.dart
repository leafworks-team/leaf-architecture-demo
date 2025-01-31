import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/PhotoRemoteDataSource.dart';
import '../../data/repositories/photo_repository_impl.dart';
import '../entities/photo_entity.dart';

final photoRepositoryProvider = Provider<PhotoRepository>(
    (ref) => PhotoRepositoryImpl(ref.watch(photoRemoteDataSourceProvider)));

abstract class PhotoRepository {
  Future<List<PhotoEntity>> getPhotos(int page, int perPage);
}
