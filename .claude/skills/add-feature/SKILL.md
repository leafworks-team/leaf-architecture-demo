---
name: add-feature
description: Clean Architecture 구조에 맞게 새 기능을 추가한다. 기능명을 인자로 받아 Entity, Repository, Model, DataSource, UseCase, ViewModel, Screen을 순서대로 생성한다.
argument-hint: [feature-name]
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# 새 기능 추가

`$ARGUMENTS` 기능을 Clean Architecture 구조에 맞게 생성한다.

## 생성 순서 및 규칙

### 1. Domain 레이어 (외부 의존성 없음)

**Entity** (`lib/domain/entities/$ARGUMENTS_entity.dart`)
- 순수 Dart 클래스
- 외부 패키지 import 금지

**Repository 인터페이스** (`lib/domain/repositories/$ARGUMENTS_repository.dart`)
- abstract class만 정의
- Data 레이어 import 금지
- Provider 연결 코드 넣지 않음

**UseCase** (`lib/domain/usecases/$ARGUMENTS_usecase.dart`)
- `@riverpod` 어노테이션으로 Provider 자동 생성
- `part '$ARGUMENTS_usecase.g.dart'` 추가
- 추상 Repository를 의존성으로 받음

### 2. Data 레이어

**Model** (`lib/data/models/$ARGUMENTS_model.dart`)
- `@freezed` sealed class
- `part '$ARGUMENTS_model.freezed.dart'` + `part '$ARGUMENTS_model.g.dart'`
- `fromJson` 팩토리 메서드
- `toEntity()` 확장 메서드로 Entity 변환

**DataSource** (`lib/data/datasources/$ARGUMENTS_remote_data_source.dart`)
- `@RestApi()` 추상 클래스 (Retrofit)
- `@riverpod` Provider 자동 생성
- `part '$ARGUMENTS_remote_data_source.g.dart'`

**Repository 구현체** (`lib/data/repositories/$ARGUMENTS_repository_impl.dart`)
- Domain의 추상 Repository를 extends
- `@riverpod` Provider 여기서 연결 (photoRepository 패턴 참고)
- `part '$ARGUMENTS_repository_impl.g.dart'`
- DataSource에서 Model을 받아 Entity로 변환

### 3. Presentation 레이어

**State** (`lib/presentation/$ARGUMENTS/state/$ARGUMENTS_state.dart`)
- Status enum 정의 (initial, loading, loaded, failure 등)
- copyWith 메서드 포함

**ViewModel** (`lib/presentation/$ARGUMENTS/viewmodels/$ARGUMENTS_viewmodel.dart`)
- `@riverpod class` + `extends _$ClassName`
- `part '$ARGUMENTS_viewmodel.g.dart'`
- `build()`에서 UseCase 주입 및 초기 상태 반환

**Screen** (`lib/presentation/$ARGUMENTS/view/$ARGUMENTS_screen.dart`)
- `@RoutePage()` 어노테이션
- `ConsumerWidget` 또는 `ConsumerStatefulWidget`
- `static const String routeName` 정의

### 4. 다국어 처리

ARB 파일 3개에 새 기능의 문자열을 추가한다.

- `lib/l10n/app_ko.arb` (한국어)
- `lib/l10n/app_en.arb` (영어)
- `lib/l10n/app_ja.arb` (일본어)

**키 네이밍 규칙**: `{screen명}_{위치}_{설명}` (snake_case)
- 예: `home_screen_tab_photo`, `photo_screen_title`

**사용법**: Screen에서 `AppLocalizations.of(context)!.키이름`으로 사용
```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

AppLocalizations.of(context)!.photo_screen_title
```

- 하드코딩된 문자열 사용 금지, 반드시 ARB를 통해 다국어 처리

### 5. 라우팅

- `lib/core/router/app_router.dart`에 라우트 추가

### 6. 코드 생성

```bash
dart run build_runner build --delete-conflicting-outputs
```

## 컨벤션

- 파일명: `snake_case.dart`
- Provider: `@riverpod`으로 자동 생성 (수동 Provider 작성 금지)
- DioClient: `leaf_architecture` 패키지에서 import
- Failure: `leaf_architecture` 패키지에서 import