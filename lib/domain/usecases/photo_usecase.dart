import 'package:architecture_sample/domain/entities/photo_entity.dart';
import 'package:architecture_sample/domain/repositories/photo_repository.dart';

class PhotoUseCase {
  final PhotoRepository repository;

  PhotoUseCase(this.repository);

  Future<List<PhotoEntity>> getPhotos(int page, int perPage) {
    return repository.getPhotos(page, perPage);
  }
}
