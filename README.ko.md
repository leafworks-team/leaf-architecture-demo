# Leaf Architecture Demo

[leaf-architecture](https://github.com/leafworks-team/leaf-architecture) 위에 앱을 어떻게 짜는지 보여 주는 작은 사진 앱입니다. Clean Architecture 레이어, Riverpod 기반 MVVM 화면, Riverpod 하나로 하는 의존성 주입, 네트워크는 Retrofit, 화면 이동은 go_router 를 씁니다. [Unsplash API](https://unsplash.com/developers) 에서 사진 목록을 받아 보여 줍니다.

[English](README.md) · **한국어**

이 앱이 따르는 규칙은 패키지의 [아키텍처 가이드](https://github.com/leafworks-team/leaf-architecture/blob/main/ARCHITECTURE.ko.md)에 정리되어 있습니다.

## 준비물

- Flutter 3.47.5 이상 (Dart 3.13.4)
- Unsplash access key ([앱 만들기](https://unsplash.com/oauth/applications))

## 시작하기

```bash
flutter pub get
dart run build_runner build

cp config/secrets.example.json config/secrets.json   # Unsplash access key 를 넣습니다
flutter run --dart-define-from-file=config/app.env --dart-define-from-file=config/secrets.json
```

- `config/app.env` 에는 공개 설정이 있고 커밋합니다.
- `config/secrets.json` 에는 키가 있고 git 이 무시합니다.
- 두 파일 없이 실행하면 앱이 시작할 때 멈추고, 어떤 파일을 넣어야 하는지 알려 줍니다.

## 프로젝트 구조

```
lib/
├── main.dart                         저장소를 열고 ProviderScope 안에서 앱을 실행
├── core/
│   ├── config/app_config.dart        빌드할 때 넣는 설정과 그 provider
│   ├── network/dio_client.dart       서버마다 DioClient provider 하나 (여기서는 Unsplash)
│   └── themes/themes.dart            라이트 · 다크 테마
├── di/
│   └── usecase_providers.dart        유스케이스 provider
├── domain/
│   ├── entities/                     PhotoEntity, PhotoFailure
│   ├── repositories/                 PhotoRepository (추상)
│   └── usecases/                     PhotoUseCase
├── data/
│   ├── datasources/                  PhotoRemoteDataSource (Retrofit)
│   ├── models/                       toEntity() 가 있는 PhotoModel (Freezed)
│   └── repositories/                 PhotoRepositoryImpl 과 그 provider
├── presentation/
│   ├── home/view/                    탭 컨테이너
│   ├── photo/                        view · viewmodels · state
│   ├── favorite/view/                자리만 잡아 둔 탭
│   └── router/app_router.dart        go_router 설정과 라우트 경로
└── l10n/                             ARB 파일 (en, ja, ko). 한국어가 원본
```

의존 방향은 안쪽입니다: `presentation → domain ← data`, 그리고 `core` 는 이들 중 어느 것도 import 하지 않습니다.

## 요청이 흐르는 순서

1. `PhotoScreen` 이 `PhotoViewModel` 에 첫 페이지를 요청합니다.
2. ViewModel 이 `PhotoUseCase` 를, 유스케이스가 `PhotoRepository` 인터페이스를 부릅니다.
3. `PhotoRepositoryImpl` 이 Retrofit `PhotoRemoteDataSource` 를 부르고, 데이터 소스는 Unsplash 용 `DioClient` 를 씁니다.
4. Repository 가 `PhotoModel` 을 `PhotoEntity` 로 바꿉니다. 실패하면 leaf_architecture 의 `Failure` 를 `PhotoFailure` 로 바꿔서 ViewModel 은 Dio 를 모릅니다.
5. ViewModel 이 Freezed `PhotoState` 를 내보내고, 화면은 그리드, 다시 시도 버튼, 스낵바 중 하나를 보여 줍니다.

## 의존성 주입

설정, DioClient, 데이터 소스, Repository, 유스케이스, ViewModel, 그리고 leaf_architecture 의 `StorageService`까지 모두 Riverpod(`@riverpod`)으로 주입합니다. [Flutter 아키텍처 가이드](https://docs.flutter.dev/app-architecture/recommendations)가 전역으로 꺼내 쓰는 객체를 피하라고 하므로 GetIt 같은 서비스 로케이터는 쓰지 않습니다.

저장소는 비동기로 열리므로 `main`이 `runApp` 전에 열어서 provider 를 덮어씁니다.

```dart
final storage = await StorageService.open();
runApp(ProviderScope(
  overrides: [storageServiceProvider.overrideWithValue(storage)],
  child: const ArchitectureSampleApp(),
));
```

## 화면 이동

go_router 설정은 모두 `presentation/router/app_router.dart` 에 있습니다. 라우터가 화면을 import 하므로 core 가 아니라 presentation 에 둡니다.

- 라우터가 다시 만들어지면 화면 스택이 처음으로 돌아가므로, `appRouterProvider` 는 keepAlive provider 로 두고 다른 provider 를 watch 하지 않습니다. redirect 에서 앱 상태가 필요하면 `ref.read` 를 씁니다.
- 경로는 `Routes` 상수로 두므로 화면에 경로 문자열을 직접 쓰지 않습니다.
- 탭은 `StatefulShellRoute.indexedStack` 이라서 탭마다 자기 스택을 유지합니다. `HomeScreen` 이 하단 바를 그리고 `goBranch` 로 탭을 바꿉니다.
- 다이얼로그와 바텀 시트는 라우트로 만들지 않고 `showDialog`, `showModalBottomSheet` 로 띄웁니다.

## 테스트

```bash
flutter test
```

`test/photo_test.dart` 는 Repository(응답 변환, access key 헤더, 가짜 HTTP 어댑터로 실패 변환), ViewModel(페이지 넘김, 실패), 화면의 다시 시도 흐름을 확인합니다. `test/home_test.dart` 는 앱 전체를 띄워 두 탭 사이를 오갑니다. 테스트는 define 대신 provider 를 바꿔 끼웁니다.

## 코드 생성

```bash
dart run build_runner build    # 또는: dart run build_runner watch
```

- 생성 파일(`*.g.dart`, `*.freezed.dart`, `*.config.dart`, `app_localizations*.dart`)은 git 이 무시하므로, 받은 뒤 생성기를 한 번 돌립니다.
- riverpod_generator 가 따라올 때까지 build_runner 는 2.17 아래에 둡니다. 이유는 `pubspec.yaml` 에 적혀 있습니다.

## Claude Code 스킬

`.claude/skills/` 에 이 규칙을 따르는 스킬이 있습니다: `add-feature`, `add-api`, `add-model`, `review-arch`.

## 연혁

[leaf-flutter-architecture](https://github.com/Im-Tae/leaf-flutter-architecture) 의 예제 앱에서 시작했습니다. 패키지는 지금 별도 저장소에 있고, 이 앱은 그것을 git 의존성으로 씁니다.
