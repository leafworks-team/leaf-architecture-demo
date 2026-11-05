---
name: review-arch
description: 현재 코드가 Clean Architecture 규칙과 프로젝트 컨벤션을 준수하는지 검사한다. 위반 사항을 찾아 보고한다.
allowed-tools: Read, Glob, Grep
---

# 아키텍처 리뷰

전체 프로젝트를 검사하여 Clean Architecture 규칙과 프로젝트 컨벤션 위반을 찾는다.

## 검사 항목

### 1. 의존성 방향 위반

Domain 레이어(`lib/domain/`)가 Data 레이어(`lib/data/`)를 import하는지 검사한다.

- `lib/domain/` 전체 → Flutter · Dio · 저장소 · data · presentation import 금지 (예외: 순수 Dart인 `lib/core/utils/`)
- `lib/domain/repositories/` → 추상 클래스만 존재해야 함
- `lib/domain/usecases/` → Provider를 두지 않는다. UseCase Provider는 `lib/di/usecase_providers.dart`에
- `lib/core/` → domain · data · presentation · di import 금지. domain 타입이 필요한 위젯은 `lib/presentation/common/`에

### 2. Provider 위치

- Repository Provider → `data/repositories/` 구현체와 함께 있어야 함 (domain에 있으면 위반)
- ViewModel Provider → `presentation/{feature}/viewmodels/`에 `@riverpod`으로 있어야 함
- 수동 `Provider()`, `StateNotifierProvider()`, `NotifierProvider()` 사용은 위반 (`@riverpod` 사용 필수)

### 3. 파일명 컨벤션

- 모든 `.dart` 파일은 `snake_case`여야 함
- `PascalCase.dart`, `camelCase.dart` 파일은 위반

### 4. Freezed 모델 규칙

- `lib/data/models/`의 모델은 `@freezed sealed class`여야 함
- `part '*.freezed.dart'` + `part '*.g.dart'` 선언이 있어야 함
- `toEntity()` 확장 메서드가 있어야 함

### 5. DataSource 규칙

- `lib/data/datasources/`의 원격 DataSource는 `@RestApi()` Retrofit 인터페이스여야 함 (파일 · 저장소를 다루는 로컬 DataSource는 일반 클래스 가능)
- Dio를 직접 호출하면 위반
- Retrofit은 `package:leaf_architecture/network.dart`로만 import (UI 파일에서 import하면 위반)

### 6. DI 컨벤션

- ViewModel, UseCase, Repository, StorageService 같은 인프라까지 모두 Riverpod `@riverpod`으로 주입하는지 확인
- GetIt 같은 서비스 로케이터(`getIt<T>()`)를 쓰면 위반
- 비동기로 여는 인프라(StorageService 등)는 `main`에서 열어 `ProviderScope(overrides: ...)`로 넣는지 확인

### 7. 미사용 import / 변수

`flutter analyze` 결과에서 warning을 확인한다.

## 출력 형식

검사 결과를 다음 형식으로 보고한다:

```
## 아키텍처 리뷰 결과

### 위반 사항
- [ ] {파일 경로}: {위반 내용} ({검사 항목 번호})

### 통과
- [x] 의존성 방향
- [x] Provider 위치
...
```

위반이 없으면 "모든 검사 항목을 통과했습니다."로 보고한다.
