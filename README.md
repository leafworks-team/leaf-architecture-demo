# Flutter Architecture Sample

Flutter Clean Architecture + MVVM

## 🚀 시작하기

### 필수 요구사항

- Flutter SDK: 3.27.3 이상
- Dart SDK: 3.6.1 이상

### 환경 설정

1. Flutter SDK 설치
```bash
# Flutter 버전 확인
flutter --version

# Flutter 최신 버전으로 업데이트
flutter upgrade
```

2. 프로젝트 클론
```bash
git clone [repository-url]
cd [project-name]
```

3. 의존성 설치
```bash
flutter pub get
```

4. 코드 생성
```bash
# 생성된 코드 삭제 후 재생성 (권장)
flutter pub run build_runner build --delete-conflicting-outputs

# 또는 단순 생성
flutter pub run build_runner build
```

### 환경 변수 설정

1. vault를 통해서 `constants.dart` 생성
```
vault kv get -field=value secret/sample/constants.dart > lib/constants.dart
```

## 📁 프로젝트 구조

```
lib/
  ├── core/
  │   ├── network/
  │   │   ├── failures.dart
  │   │   └── dio_client.dart
  │   ├── themes/
  │   │   └── themes.dart
  │   ├── router/
  │   │   └── app_router.dart
  │   └── utils/
  │
  ├── di/
  │   ├── injection.dart
  │   └── modules/
  │   
  ├── data/
  │   ├── datasources/
  │   │   └── remote/
  │   │       └── user_remote_datasource.dart
  │   │   └── local/
  │   │       └── user_local_datasource.dart
  │   ├── models/
  │   │   └── user_model.dart
  │   └── repositories/
  │       └── user_repository_impl.dart
  │
  ├── domain/
  │   ├── entities/
  │   │   └── user.dart
  │   ├── repositories/
  │   │   └── user_repository.dart
  │   └── usecases/
  │       └── get_user_profile.dart
  │
  ├── presentation/
  │     ├── profile/
  │     │   ├── state/
  │     │   │   └── profile_state.dart
  │     │   │── view/
  │     │   │   └── profile_screen.dart
  │     │   │── viewmodels/
  │     │   │   └── profile_viewmodel.dart
  │     │   └── widgets/
  │     │       └── ...
  │     └── common/
  │  
  └── constants.dart
```

## 🔄 코드 생성 명령어

새로운 freezed 모델이나 retrofit API 클라이언트를 추가한 후에는 항상 다음 명령어를 실행해야 합니다:

```bash
# Watch 모드 (파일 변경 감지하여 자동 생성)
flutter pub run build_runner watch

# 한 번만 생성
flutter pub run build_runner build

# 충돌 파일 삭제 후 생성
flutter pub run build_runner build --delete-conflicting-outputs
```

## 📱 앱 실행

1. 에뮬레이터 또는 실제 디바이스 연결
2. 다음 명령어로 앱 실행
```bash
flutter run
```

## 🧪 테스트 실행

```bash
# 전체 테스트 실행
flutter test

# 특정 테스트 파일 실행
flutter test test/path/to/test_file.dart
```

## 📝 코딩 컨벤션

- [flutter_lints](https://pub.dev/packages/flutter_lints) 규칙을 따릅니다.

## ❗️ 주의사항

- `.env` 파일과 같은 민감한 정보는 절대 커밋하지 않습니다.
- 생성된 코드 파일들 (*.freezed.dart, *.g.dart 등)은 커밋하지 않습니다.
- main 브랜치에 직접 push하지 않습니다.