# Flutter Architecture Sample

Flutter Clean Architecture + MVVM 기반 샘플 프로젝트입니다.

공통 아키텍처는 `leaf_architecture` 패키지로 분리되어 다른 프로젝트에서도 재사용할 수 있습니다.

## 시작하기

### 필수 요구사항

- Flutter SDK: 3.27.0 이상
- Dart SDK: 3.8.0 이상

### 환경 설정

```bash
# 1. 프로젝트 클론
git clone [repository-url]
cd [project-name]

# 2. 의존성 설치
flutter pub get

# 3. 코드 생성
dart run build_runner build --delete-conflicting-outputs
```

## 프로젝트 구조

```
leaf-flutter-architecture/
├── lib/                                    # 샘플 앱 (Photo)
│   ├── main.dart                           # 앱 진입점
│   ├── constants.dart                      # API 키 등 앱 설정 (gitignore)
│   │
│   ├── core/
│   │   ├── network/
│   │   │   └── dio_client.dart             # 앱별 DioClient Provider
│   │   ├── router/
│   │   │   └── app_router.dart             # 앱별 라우팅 설정
│   │   └── themes/
│   │       └── themes.dart                 # 앱별 테마
│   │
│   ├── di/
│   │   └── injection.dart                  # 앱 DI 초기화 (Injectable)
│   │
│   ├── domain/                             # 도메인 레이어 (순수 비즈니스 로직)
│   │   ├── entities/
│   │   │   └── photo_entity.dart           # 비즈니스 엔티티
│   │   ├── repositories/
│   │   │   └── photo_repository.dart       # 추상 Repository 인터페이스
│   │   └── usecases/
│   │       └── photo_usecase.dart          # UseCase
│   │
│   ├── data/                               # 데이터 레이어 (외부 데이터 처리)
│   │   ├── datasources/
│   │   │   └── photo_remote_data_source.dart  # Retrofit API 인터페이스
│   │   ├── models/
│   │   │   └── photo_model.dart            # JSON 직렬화 모델 (Freezed)
│   │   └── repositories/
│   │       └── photo_repository_impl.dart  # Repository 구현체 + Provider
│   │
│   ├── presentation/                       # 프레젠테이션 레이어 (UI)
│   │   ├── home/
│   │   │   ├── view/
│   │   │   │   └── home_screen.dart        # 탭 네비게이션 컨테이너
│   │   │   ├── viewmodels/
│   │   │   │   └── home_viewmodel.dart     # @riverpod ViewModel
│   │   │   └── state/
│   │   │       └── home_state.dart         # 상태 클래스
│   │   ├── photo/
│   │   │   ├── view/
│   │   │   │   └── photo_screen.dart
│   │   │   ├── viewmodels/
│   │   │   │   └── photo_viewmodel.dart
│   │   │   └── state/
│   │   │       └── photo_state.dart
│   │   └── favorite/
│   │       └── view/
│   │           └── favorite_screen.dart
│   │
│   └── l10n/                               # 다국어 지원 (en, ja, ko)
│       ├── app_en.arb
│       ├── app_ja.arb
│       └── app_ko.arb
│
└── packages/
    └── leaf_architecture/                  # 재사용 가능한 아키텍처 패키지
        └── lib/
            └── src/
                ├── network/
                │   ├── dio_client.dart      # 설정 가능한 HTTP 클라이언트
                │   └── failures.dart        # 에러 타입 (Freezed)
                ├── storage/
                │   ├── storage_service.dart  # 스토리지 추상화
                │   └── storage_module.dart   # Injectable 모듈
                └── di/
                    └── injection.dart        # GetIt 인스턴스
```

## 아키텍처

### 레이어 구조

```
Presentation  →  Domain  ←  Data
(UI/State)     (Business)   (API/DB)
```

- **Domain**: 순수 비즈니스 로직. 다른 레이어에 의존하지 않음
- **Data**: Domain의 인터페이스를 구현. 외부 API/DB 접근
- **Presentation**: UI와 상태 관리. Domain의 UseCase를 사용

### DI 컨벤션

| DI | 역할 | 대상 |
|---|---|---|
| **GetIt / Injectable** | 인프라 / 플랫폼 레벨 | Storage 등 Widget 트리 밖에서도 접근 필요한 의존성 |
| **Riverpod / @riverpod** | UI / 비즈니스 로직 레벨 | ViewModel, UseCase, Repository 등 |

### 코드 생성 도구

| 도구 | 용도 |
|---|---|
| **Freezed** | 불변 데이터 클래스, sealed class |
| **Riverpod Generator** | `@riverpod` → Provider 자동 생성 |
| **Retrofit Generator** | `@RestApi` → API 클라이언트 자동 생성 |
| **Json Serializable** | JSON 직렬화/역직렬화 |
| **Injectable Generator** | GetIt DI 설정 자동 생성 |
| **Auto Route Generator** | 타입 안전한 라우팅 |

## 코드 생성 명령어

```bash
# 한 번 생성
dart run build_runner build --delete-conflicting-outputs

# Watch 모드 (파일 변경 감지하여 자동 생성)
dart run build_runner watch --delete-conflicting-outputs
```

## 주의사항

- `constants.dart` 등 민감한 정보는 커밋하지 않습니다.
- 생성된 코드 파일들 (`*.freezed.dart`, `*.g.dart`, `*.gr.dart`, `*.config.dart`)은 커밋하지 않습니다.
- 다국어 파일 (`app_localizations*.dart`)은 ARB 파일로부터 자동 생성되므로 커밋하지 않습니다.
