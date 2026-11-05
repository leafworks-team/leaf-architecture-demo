import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

@RoutePage()
class FavoriteScreen extends StatelessWidget {
  static const String routeName = 'favorite';

  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(strings.home_screen_tab_favorite)),
      body: Center(child: Text(strings.favorite_screen_empty)),
    );
  }
}
