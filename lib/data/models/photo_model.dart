import 'package:architecture_sample/domain/entities/photo_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'photo_model.freezed.dart';

part 'photo_model.g.dart';

@freezed
class PhotoModel with _$PhotoModel {
  const factory PhotoModel({
    required String id,
    required String url,
    required String thumbUrl,
    String? description,
  }) = _PhotoModel;

  factory PhotoModel.fromJson(Map<String, dynamic> json) =>
      _$PhotoModelFromJson({
        ...json,
        'url': json['urls']['regular'],
        'thumbUrl': json['urls']['thumb'],
      });
}

extension PhotoExtension on PhotoModel {
  PhotoEntity toEntity() => PhotoEntity(
    id: id,
    url: url,
    thumbUrl: thumbUrl,
    description: description,
  );
}