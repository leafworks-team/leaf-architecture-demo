---
name: add-api
description: 기존 Retrofit DataSource에 새 API 엔드포인트를 추가한다. DataSource 파일명과 API 정보를 인자로 받는다.
argument-hint: [data_source_name] [HTTP_METHOD] [/endpoint]
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# API 엔드포인트 추가

`$ARGUMENTS` 정보를 기반으로 Retrofit DataSource에 새 API 엔드포인트를 추가한다.

## 작업 순서

### 1. DataSource 파일 찾기

`lib/data/datasources/` 에서 해당 DataSource 파일을 찾는다.

### 2. 필요한 Model 확인

- 요청/응답에 필요한 Model이 없으면 먼저 생성한다.
- Model은 `@freezed` sealed class + `fromJson` + `toEntity()` 패턴을 따른다.

### 3. 엔드포인트 추가

Retrofit 어노테이션으로 추상 메서드를 추가한다.

```dart
@GET('/endpoint')
Future<ResponseModel> getItem(@Path('id') String id);

@POST('/endpoint')
Future<ResponseModel> createItem(@Body() RequestModel body);

@PUT('/endpoint/{id}')
Future<ResponseModel> updateItem(
  @Path('id') String id,
  @Body() RequestModel body,
);

@DELETE('/endpoint/{id}')
Future<void> deleteItem(@Path('id') String id);
```

### 4. 자주 쓰는 Retrofit 어노테이션

| 어노테이션 | 용도 |
|---|---|
| `@Path('name')` | URL 경로 파라미터 |
| `@Query('name')` | 쿼리 파라미터 |
| `@Body()` | 요청 본문 |
| `@Header('name')` | 커스텀 헤더 |
| `@Field('name')` | Form 필드 (`@FormUrlEncoded` 필요) |

### 5. Repository에 메서드 추가

- `domain/repositories/` 추상 인터페이스에 메서드 추가
- `data/repositories/` 구현체에 메서드 구현

### 6. UseCase 업데이트

필요시 UseCase에 새 메서드를 추가한다.

### 7. 코드 생성

```bash
dart run build_runner build --delete-conflicting-outputs
```
