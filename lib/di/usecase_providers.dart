import 'package:architecture_sample/data/repositories/photo_repository_impl.dart';
import 'package:architecture_sample/domain/usecases/photo_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'usecase_providers.g.dart';

@riverpod
PhotoUseCase photoUseCase(Ref ref) =>
    PhotoUseCase(ref.watch(photoRepositoryProvider));