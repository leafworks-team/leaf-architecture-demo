---
name: add-model
description: Freezed 모델과 매핑할 Entity를 함께 생성한다. 모델명과 필드를 인자로 받는다.
argument-hint: [ModelName field1:Type field2:Type ...]
allowed-tools: Read, Write, Edit, Bash
---

# Freezed 모델 생성

`$ARGUMENTS`를 기반으로 Model과 Entity를 생성한다.

## 생성 파일

### 1. Entity (`lib/domain/entities/{name}_entity.dart`)

- 순수 Dart 클래스
- 외부 패키지 import 없음

```dart
class {Name}Entity {
  final Type field1;
  final Type field2;

  {Name}Entity({required this.field1, required this.field2});
}
```

### 2. Model (`lib/data/models/{name}_model.dart`)

- `@freezed` sealed class
- `part` 선언 필수
- `fromJson` 팩토리 메서드
- `toEntity()` 확장 메서드

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part '{name}_model.freezed.dart';
part '{name}_model.g.dart';

@freezed
sealed class {Name}Model with _${Name}Model {
  const factory {Name}Model({
    required Type field1,
    required Type field2,
  }) = _{Name}Model;

  factory {Name}Model.fromJson(Map<String, dynamic> json) =>
      _${Name}ModelFromJson(json);
}

extension {Name}Extension on {Name}Model {
  {Name}Entity toEntity() => {Name}Entity(
    field1: field1,
    field2: field2,
  );
}
```

## 규칙

- 파일명: `snake_case.dart`
- API 응답 필드명과 Dart 필드명이 다르면 `@JsonKey(name: 'api_field')` 사용
- 중첩 JSON 매핑이 필요하면 커스텀 `fromJson`에서 처리
- 생성 후 `dart run build_runner build` 실행
