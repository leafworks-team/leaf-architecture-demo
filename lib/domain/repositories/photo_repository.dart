import '../entities/photo_entity.dart';

abstract class PhotoRepository {
  Future<List<PhotoEntity>> getPhotos(int page, int perPage);
}
