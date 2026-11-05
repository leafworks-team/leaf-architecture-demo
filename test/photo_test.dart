import 'dart:convert';
import 'dart:typed_data';

import 'package:architecture_sample/core/config/app_config.dart';
import 'package:architecture_sample/core/network/dio_client.dart';
import 'package:architecture_sample/data/repositories/photo_repository_impl.dart';
import 'package:architecture_sample/domain/entities/photo_entity.dart';
import 'package:architecture_sample/domain/entities/photo_failure.dart';
import 'package:architecture_sample/domain/repositories/photo_repository.dart';
import 'package:architecture_sample/l10n/app_localizations.dart';
import 'package:architecture_sample/presentation/photo/state/photo_state.dart';
import 'package:architecture_sample/presentation/photo/view/photo_screen.dart';
import 'package:architecture_sample/presentation/photo/viewmodels/photo_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leaf_architecture/network.dart';

/// Answers every request with [status] and [body], or fails the connection when [status] is null.
class FakeServer implements HttpClientAdapter {
  FakeServer(this.status, [this.body = const []]);

  final int? status;
  final Object body;
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final status = this.status;
    if (status == null) throw DioException.connectionError(requestOptions: options, reason: 'offline');
    return ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        'content-type': ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

/// Replaces the repository so view model tests need no network.
class FakeRepository implements PhotoRepository {
  final pages = <int, Object>{}; // page → List<PhotoEntity> or PhotoFailure

  @override
  Future<List<PhotoEntity>> getPhotos(int page, int perPage) async => switch (pages[page]) {
    final PhotoFailure failure => throw failure,
    final List<PhotoEntity> photos => photos,
    _ => const [],
  };
}

PhotoEntity photo(String id) => PhotoEntity(id: id, url: 'https://img.test/$id', thumbUrl: 'https://img.test/$id/t');

Map<String, Object?> photoJson(String id) => {
  'id': id,
  'description': null,
  'urls': {'regular': 'https://img.test/$id', 'thumb': 'https://img.test/$id/t'},
};

const config = AppConfig(baseUrl: 'https://api.test', accessKey: 'test-key');

void main() {
  group('PhotoRepositoryImpl', () {
    ProviderContainer containerFor(FakeServer server) {
      final container = ProviderContainer(overrides: [appConfigProvider.overrideWithValue(config)]);
      addTearDown(container.dispose);
      container.read(unsplashDioClientProvider).dio.httpClientAdapter = server;
      return container;
    }

    test('maps the response to entities and sends the access key', () async {
      final server = FakeServer(200, [photoJson('a'), photoJson('b')]);
      final photos = await containerFor(server).read(photoRepositoryProvider).getPhotos(1, 20);
      expect(photos.map((photo) => photo.id), ['a', 'b']);
      expect(photos.first.thumbUrl, 'https://img.test/a/t');
      expect(server.requests.single.headers['Authorization'], 'Client-ID test-key');
      expect(server.requests.single.uri.queryParameters, {'page': '1', 'per_page': '20'});
    });

    test('turns transport errors into PhotoFailure', () async {
      Future<PhotoFailureKind?> kindFor(FakeServer server) async {
        try {
          await containerFor(server).read(photoRepositoryProvider).getPhotos(1, 20);
        } on PhotoFailure catch (failure) {
          return failure.kind;
        }
        return null;
      }

      expect(
        await kindFor(
          FakeServer(500, {
            'errors': ['oops'],
          }),
        ),
        PhotoFailureKind.server,
      );
      expect(await kindFor(FakeServer(null)), PhotoFailureKind.network);
    });
  });

  group('PhotoViewModel', () {
    late FakeRepository repository;
    late ProviderContainer container;

    setUp(() {
      repository = FakeRepository();
      container = ProviderContainer(overrides: [photoRepositoryProvider.overrideWithValue(repository)]);
      addTearDown(container.dispose);
      container.listen(photoViewModelProvider, (_, _) {}); // keeps the auto-dispose provider alive
    });

    PhotoState read() => container.read(photoViewModelProvider);
    PhotoViewModel viewModel() => container.read(photoViewModelProvider.notifier);

    test('loads the first page, then appends the next one', () async {
      repository.pages[1] = [photo('a'), photo('b')];
      repository.pages[2] = [photo('c')];
      await viewModel().fetchPhotos();
      expect(read().status, PhotoStatus.loaded);
      await viewModel().fetchMorePhotos();
      expect(read().photos.map((photo) => photo.id), ['a', 'b', 'c']);
      expect(read().page, 2);
    });

    test('a failed first page shows the failure', () async {
      repository.pages[1] = const PhotoFailure(PhotoFailureKind.network);
      await viewModel().fetchPhotos();
      expect(read().status, PhotoStatus.failure);
      expect(read().failure, PhotoFailureKind.network);
    });

    test('a failed next page keeps the photos already shown', () async {
      repository.pages[1] = [photo('a')];
      repository.pages[2] = const PhotoFailure(PhotoFailureKind.server);
      await viewModel().fetchPhotos();
      await viewModel().fetchMorePhotos();
      expect(read().status, PhotoStatus.loaded);
      expect(read().photos.map((photo) => photo.id), ['a']);
      expect(read().failure, PhotoFailureKind.server);
    });
  });

  testWidgets('PhotoScreen offers a retry when the first page fails', (tester) async {
    final repository = FakeRepository()..pages[1] = const PhotoFailure(PhotoFailureKind.network);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [photoRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(
          locale: Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: PhotoScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Check your internet connection'), findsOneWidget);

    repository.pages[1] = <PhotoEntity>[];
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(find.text('No photos'), findsOneWidget);
  });
}
