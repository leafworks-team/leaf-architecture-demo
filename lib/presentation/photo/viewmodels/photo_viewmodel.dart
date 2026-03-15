import 'package:architecture_sample/di/usecase_providers.dart';
import 'package:architecture_sample/domain/usecases/photo_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../state/photo_state.dart';

part 'photo_viewmodel.g.dart';

@riverpod
class PhotoViewModel extends _$PhotoViewModel {
  late final PhotoUseCase useCase;

  @override
  PhotoState build() {
    useCase = ref.watch(photoUseCaseProvider);
    return PhotoState();
  }

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
