// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get app_title => 'アーキテクチャ サンプル アプリ';

  @override
  String get home_screen_tab_photo => 'フォト';

  @override
  String get home_screen_tab_favorite => 'お気に入り';

  @override
  String get photo_screen_empty => '写真がありません';

  @override
  String get photo_screen_retry => '再試行';

  @override
  String get photo_screen_failure_network => 'インターネット接続を確認してください';

  @override
  String get photo_screen_failure_server => 'サーバーから写真を取得できませんでした';

  @override
  String get photo_screen_failure_unknown => '写真を読み込めませんでした';

  @override
  String get favorite_screen_empty => 'お気に入りの写真はまだありません';
}
