# Leaf Architecture

Flutter 프로젝트에서 공통으로 사용할 수 있는 아키텍처 기반 패키지입니다.

## 제공 기능

### Network

- **DioClient** - Dio 기반 HTTP 클라이언트. `baseUrl`, `headers`, `interceptors`를 주입받아 설정합니다. 네트워크 에러를 자동으로 `Failure` 타입으로 변환하는 인터셉터가 내장되어 있습니다.
- **Failure** - Freezed 기반 에러 타입. `ServerFailure`, `NetworkFailure`, `CacheFailure` 세 가지 유형을 제공합니다.

### Storage

- **StorageService** - `GetStorage`(일반 저장소)와 `FlutterSecureStorage`(암호화 저장소)를 통합한 저장소 서비스입니다.
- **StorageModule** - Injectable 모듈. `GetStorage`와 `FlutterSecureStorage` 의존성을 자동으로 주입합니다.

### DI

- **getIt** - `GetIt` 서비스 로케이터 인스턴스를 제공합니다.

## 설치

### Git dependency

```yaml
dependencies:
  leaf_architecture:
    git:
      url: https://github.com/Im-Tae/leaf-flutter-architecture.git
      path: packages/leaf_architecture
```

### Path dependency (모노레포)

```yaml
dependencies:
  leaf_architecture:
    path: packages/leaf_architecture
```

## 사용법

### 1. Import

```dart
import 'package:leaf_architecture/leaf_architecture.dart';
```

### 2. DioClient 설정

Riverpod Provider로 앱에 맞는 설정을 주입합니다.

```dart
@riverpod
DioClient dioClient(Ref ref) => DioClient(
      baseUrl: 'https://api.example.com',
      headers: {'Authorization': 'Bearer $token'},
    );
```

커스텀 인터셉터를 추가할 수도 있습니다.

```dart
@riverpod
DioClient dioClient(Ref ref) => DioClient(
      baseUrl: 'https://api.example.com',
      interceptors: [LogInterceptor()],
    );
```

### 3. Failure 처리

API 호출 시 에러를 패턴 매칭으로 처리합니다.

```dart
try {
  final response = await dioClient.dio.get('/endpoint');
} on DioException catch (e) {
  final failure = e.error as Failure;
  switch (failure) {
    case ServerFailure(:final message):
      print('서버 에러: $message');
    case NetworkFailure():
      print('네트워크 연결 실패');
    case CacheFailure():
      print('캐시 에러');
  }
}
```

### 4. StorageService 사용

Injectable로 주입받아 사용합니다.

```dart
final storage = getIt<StorageService>();

// 일반 저장소
await storage.write('key', 'value');
final value = storage.read<String>('key');
await storage.delete('key');

// 암호화 저장소
await storage.writeSecure('token', 'secret_value');
final token = await storage.readSecure('token');
await storage.deleteSecure('token');

// 전체 삭제
await storage.clear();
```

### 5. DI 설정

앱의 `injection.dart`에서 `getIt` 인스턴스를 사용합니다.

```dart
import 'package:leaf_architecture/leaf_architecture.dart';
import 'package:injectable/injectable.dart';
import 'injection.config.dart';

@InjectableInit()
Future<void> configureDependencies() async => getIt.init();
```

## DI 컨벤션

이 프로젝트는 GetIt과 Riverpod 두 가지 DI를 사용하며, 역할이 명확히 구분됩니다.

| DI | 역할 | 대상 |
|---|---|---|
| **GetIt / Injectable** | 인프라 / 플랫폼 레벨 | Storage, 네이티브 서비스 등 Widget 트리 밖에서도 접근이 필요한 의존성 |
| **Riverpod / @riverpod** | UI / 비즈니스 로직 레벨 | ViewModel, UseCase, Repository, DioClient 등 Widget 트리 안에서 사용하는 의존성 |

### 왜 두 가지를 쓰나요?

Riverpod은 `Ref`가 필요하므로 Widget 트리 밖(백그라운드 서비스, 네이티브 플랫폼 콜백 등)에서는 접근이 불가능합니다. GetIt은 `getIt<T>()`로 어디서든 접근할 수 있어 인프라 레벨 의존성에 적합합니다.

### 판단 기준

- Widget 트리 안에서만 사용 → **Riverpod**
- Widget 트리 밖에서도 접근 필요 → **GetIt**

## 의존성

| 패키지 | 용도 |
|---|---|
| dio | HTTP 클라이언트 |
| freezed_annotation | 불변 데이터 클래스 |
| get_it | 서비스 로케이터 |
| injectable | DI 어노테이션 |
| get_storage | 로컬 저장소 |
| flutter_secure_storage | 암호화 저장소 |
