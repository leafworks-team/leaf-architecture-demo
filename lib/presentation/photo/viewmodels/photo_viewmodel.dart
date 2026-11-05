import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../di/usecase_providers.dart';
import '../../../domain/entities/photo_failure.dart';
import '../state/photo_state.dart';

part 'photo_viewmodel.g.dart';

@riverpod
class PhotoViewModel extends _$PhotoViewModel {
  static const perPage = 20;

  @override
  PhotoState build() => const PhotoState();

  /// Loads the first page, replacing what is shown.
  Future<void> fetchPhotos() async {
    state = state.copyWith(status: PhotoStatus.loading, failure: null);
    try {
      final photos = await ref.read(photoUseCaseProvider).getPhotos(1, perPage);
      if (ref.mounted) state = state.copyWith(status: PhotoStatus.loaded, photos: photos, page: 1);
    } on PhotoFailure catch (failure) {
      if (ref.mounted) state = state.copyWith(status: PhotoStatus.failure, failure: failure.kind);
    }
  }

  /// Appends the next page. Ignored while a page is already loading.
  Future<void> fetchMorePhotos() async {
    if (state.status == PhotoStatus.loading || state.status == PhotoStatus.fetchingMore) return;
    state = state.copyWith(status: PhotoStatus.fetchingMore);
    try {
      final next = state.page + 1;
      final photos = await ref.read(photoUseCaseProvider).getPhotos(next, perPage);
      if (ref.mounted) {
        state = state.copyWith(status: PhotoStatus.loaded, photos: [...state.photos, ...photos], page: next);
      }
    } on PhotoFailure catch (failure) {
      // Keep the photos already shown; only the next page failed.
      if (ref.mounted) state = state.copyWith(status: PhotoStatus.loaded, failure: failure.kind);
    }
  }
}
