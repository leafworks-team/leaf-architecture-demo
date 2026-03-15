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

- `lib/domain/entities/` → 외부 패키지 import 금지
- `lib/domain/repositories/` → Data 레이어 import 금지, 추상 클래스만 존재해야 함
- `lib/domain/usecases/` → Data 레이어의 Repository Provider import는 허용 (DI 연결)

**예외**: UseCase의 `@riverpod` Provider가 Repository Provider를 참조하는 것은 허용.

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

- `lib/data/datasources/`의 DataSource는 `@RestApi()` Retrofit 인터페이스여야 함
- Dio를 직접 호출하면 위반

### 6. DI 컨벤션

- StorageService 등 인프라 레벨 → GetIt/Injectable 사용 확인
- ViewModel, UseCase, Repository 등 → Riverpod `@riverpod` 사용 확인
- 두 DI가 혼용되면 위반 (역할별로 분리되어야 함)

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
