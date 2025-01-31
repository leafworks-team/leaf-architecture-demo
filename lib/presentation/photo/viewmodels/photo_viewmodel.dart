import 'package:architecture_sample/domain/usecases/photo_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/photo_state.dart';

final photoViewModelProvider =
    StateNotifierProvider<PhotoViewModel, PhotoState>((ref) {
  final photoUseCase = ref.watch(photoUseCaseProvider);
  return PhotoViewModel(photoUseCase);
});

class PhotoViewModel extends StateNotifier<PhotoState> {
  final PhotoUseCase useCase;

  PhotoViewModel(this.useCase) : super(PhotoState());

  Future<void> fetchPhotos(int page, int perPage) async {
    state = state.copyWith(status: PhotoStatus.loading);

    try {
      final photos = await useCase.getPhotos(page, perPage);
      state = state.copyWith(
        status: PhotoStatus.loaded,
        photos: photos,
      );
    } catch (e) {
      state = state.copyWith(
        status: PhotoStatus.failure,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> fetchMorePhotos(int page, int perPage) async {
    if (state.status == PhotoStatus.fetchingMore) return;

    state = state.copyWith(status: PhotoStatus.fetchingMore);

    try {
      final newPhotos = await useCase.getPhotos(page, perPage);
      state = state.copyWith(
        status: PhotoStatus.loaded,
        photos: [...state.photos, ...newPhotos],
      );
    } catch (e) {
      state = state.copyWith(
        status: PhotoStatus.failure,
        errorMessage: e.toString(),
      );
    }
  }
}
