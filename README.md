# Leaf Architecture Demo

A small photo app that shows how to build on [leaf-architecture](https://github.com/leafworks-team/leaf-architecture): Clean Architecture layers, MVVM screens with Riverpod, Riverpod alone for dependency injection, Retrofit for the network and go_router for navigation. It lists photos from the [Unsplash API](https://unsplash.com/developers).

**English** · [한국어](README.ko.md)

The rules this app follows are written up in the package's [architecture guide](https://github.com/leafworks-team/leaf-architecture/blob/main/ARCHITECTURE.md).

## Requirements

- Flutter 3.47.5 or later (Dart 3.13.4)
- An Unsplash access key ([create an app](https://unsplash.com/oauth/applications))

## Getting started

```bash
flutter pub get
dart run build_runner build

cp config/secrets.example.json config/secrets.json   # then put your Unsplash access key in it
flutter run --dart-define-from-file=config/app.env --dart-define-from-file=config/secrets.json
```

- `config/app.env` holds public settings and is committed.
- `config/secrets.json` holds the key and is git-ignored.
- Without them the app stops at startup and tells you which files to pass.

## Project structure

```
lib/
├── main.dart                         Opens storage, then runs the app inside a ProviderScope
├── core/
│   ├── config/app_config.dart        Build-time settings and their provider
│   ├── network/dio_client.dart       One DioClient provider per server (here: Unsplash)
│   └── themes/themes.dart            Light and dark themes
├── di/
│   └── usecase_providers.dart        Use case providers
├── domain/
│   ├── entities/                     PhotoEntity, PhotoFailure
│   ├── repositories/                 PhotoRepository (abstract)
│   └── usecases/                     PhotoUseCase
├── data/
│   ├── datasources/                  PhotoRemoteDataSource (Retrofit)
│   ├── models/                       PhotoModel (Freezed) with toEntity()
│   └── repositories/                 PhotoRepositoryImpl and its provider
├── presentation/
│   ├── home/view/                    Tab container
│   ├── photo/                        view · viewmodels · state
│   ├── favorite/view/                Placeholder tab
│   └── router/app_router.dart        go_router configuration and route paths
└── l10n/                             ARB files (en, ja, ko); Korean is the template
```

Dependencies point inward: `presentation → domain ← data`, and `core` imports none of them.

## How a request flows

1. `PhotoScreen` asks `PhotoViewModel` for the first page.
2. The view model calls `PhotoUseCase`, which calls the `PhotoRepository` interface.
3. `PhotoRepositoryImpl` calls the Retrofit `PhotoRemoteDataSource`, which uses the Unsplash `DioClient`.
4. The repository maps `PhotoModel` to `PhotoEntity`. When the call fails it turns leaf_architecture's `Failure` into a `PhotoFailure`, so the view model never sees Dio.
5. The view model publishes a Freezed `PhotoState`; the screen shows a grid, a retry button or a snack bar.

## Dependency injection

Everything goes through Riverpod (`@riverpod`): config, DioClient, data sources, repositories, use cases, view models and leaf_architecture's `StorageService`. There is no service locator such as GetIt, as the [Flutter architecture guide](https://docs.flutter.dev/app-architecture/recommendations) advises against globally accessible objects.

Storage opens asynchronously, so `main` opens it before `runApp` and overrides the provider:

```dart
final storage = await StorageService.open();
runApp(ProviderScope(
  overrides: [storageServiceProvider.overrideWithValue(storage)],
  child: const ArchitectureSampleApp(),
));
```

## Navigation

`presentation/router/app_router.dart` holds the whole go_router setup. It lives in presentation rather than core because it imports the screens.

- Rebuilding the router would reset the navigation stack, so `appRouterProvider` is a keepAlive provider that never watches another provider. A redirect that needs app state uses `ref.read`.
- Paths are constants in `Routes`, so screens never spell out a path.
- The tabs are a `StatefulShellRoute.indexedStack`, so each tab keeps its own stack. `HomeScreen` draws the bottom bar and switches tabs with `goBranch`.
- Dialogs and bottom sheets are not routes. They open with `showDialog` and `showModalBottomSheet`.

## Tests

```bash
flutter test
```

`test/photo_test.dart` covers the repository (response mapping, access key header, failure mapping through a fake HTTP adapter), the view model (paging, failures) and the screen's retry flow. `test/home_test.dart` pumps the whole app and switches between the two tabs. Tests replace providers instead of passing defines.

## Code generation

```bash
dart run build_runner build    # or: dart run build_runner watch
```

- Generated files (`*.g.dart`, `*.freezed.dart`, `*.config.dart`, `app_localizations*.dart`) are git-ignored, so run the generator after cloning.
- build_runner stays below 2.17 until riverpod_generator catches up; `pubspec.yaml` notes why.

## Claude Code skills

`.claude/skills/` has skills that follow these rules: `add-feature`, `add-api`, `add-model` and `review-arch`.

## History

Started as the example app in [leaf-flutter-architecture](https://github.com/Im-Tae/leaf-flutter-architecture). The package now lives in its own repository and this app consumes it as a git dependency.
