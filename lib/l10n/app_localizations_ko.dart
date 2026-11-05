// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get app_title => '아키텍처 샘플 앱';

  @override
  String get home_screen_tab_photo => '포토';

  @override
  String get home_screen_tab_favorite => '즐겨찾기';

  @override
  String get photo_screen_empty => '사진이 없어요';

  @override
  String get photo_screen_retry => '다시 시도';

  @override
  String get photo_screen_failure_network => '인터넷 연결을 확인해 주세요';

  @override
  String get photo_screen_failure_server => '서버에서 사진을 받지 못했어요';

  @override
  String get photo_screen_failure_unknown => '사진을 불러오지 못했어요';

  @override
  String get favorite_screen_empty => '즐겨찾기한 사진이 없어요';
}
