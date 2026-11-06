import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

class FavoriteScreen extends StatelessWidget {
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
