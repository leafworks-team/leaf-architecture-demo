import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/photo_entity.dart';
import '../../../domain/entities/photo_failure.dart';

part 'photo_state.freezed.dart';

enum PhotoStatus { initial, loading, loaded, failure, fetchingMore }

/// Compared by identity (equal: false): the photo list grows with every page.
@Freezed(equal: false)
sealed class PhotoState with _$PhotoState {
  const factory PhotoState({
    @Default(PhotoStatus.initial) PhotoStatus status,
    @Default(<PhotoEntity>[]) List<PhotoEntity> photos,
    @Default(0) int page,
    PhotoFailureKind? failure,
  }) = _PhotoState;
}
