// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_title => 'Architecture Sample App';

  @override
  String get home_screen_tab_photo => 'Photo';

  @override
  String get home_screen_tab_favorite => 'Favorite';

  @override
  String get photo_screen_empty => 'No photos';

  @override
  String get photo_screen_retry => 'Try again';

  @override
  String get photo_screen_failure_network => 'Check your internet connection';

  @override
  String get photo_screen_failure_server => 'The server did not return photos';

  @override
  String get photo_screen_failure_unknown => 'Could not load photos';

  @override
  String get favorite_screen_empty => 'No favorite photos yet';
}
