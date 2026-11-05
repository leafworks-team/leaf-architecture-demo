import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_config.g.dart';

/// Settings passed at build time with `--dart-define-from-file`, so no address or key lives in code.
///
///   config/app.env         public settings (committed)
///   config/secrets.json    keys (git-ignored; copy config/secrets.example.json)
class AppConfig {
  const AppConfig({required this.baseUrl, required this.accessKey});

  final String baseUrl;
  final String accessKey;

  static const _baseUrl = String.fromEnvironment('APP_BASE_URL');
  static const _accessKey = String.fromEnvironment('UNSPLASH_ACCESS_KEY');

  /// Fails fast when the app was started without the config files.
  static AppConfig get current {
    if (_baseUrl.isEmpty || _accessKey.isEmpty) {
      throw StateError(
        'Missing config. Run with --dart-define-from-file=config/app.env --dart-define-from-file=config/secrets.json',
      );
    }
    return const AppConfig(baseUrl: _baseUrl, accessKey: _accessKey);
  }
}

/// Tests override this provider instead of passing defines.
@Riverpod(keepAlive: true)
AppConfig appConfig(Ref ref) => AppConfig.current;
