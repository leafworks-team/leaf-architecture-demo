import 'package:architecture_sample/domain/entities/photo_entity.dart';

enum PhotoStatus {
  initial,
  loading,
  loaded,
  failure,
  fetchingMore,
}

class PhotoState {
  final PhotoStatus status;
  final List<PhotoEntity> photos;
  final PhotoEntity? selectedPhoto;

  PhotoState({
    this.status = PhotoStatus.initial,
    this.photos = const [],
    this.selectedPhoto,
  });

  PhotoState copyWith({
    PhotoStatus? status,
    List<PhotoEntity>? photos,
    PhotoEntity? selectedPhoto,
    String? errorMessage,
  }) {
    return PhotoState(
      status: status ?? this.status,
      photos: photos ?? this.photos,
      selectedPhoto: selectedPhoto ?? this.selectedPhoto,
    );
  }
}
