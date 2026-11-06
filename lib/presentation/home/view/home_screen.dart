import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';

/// Tab container. It holds no state of its own, so it needs no view model.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.navigationShell});

  /// Holds one navigator per tab, built by the router.
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        // Tapping the tab that is already open takes it back to its first screen.
        onDestinationSelected: (index) =>
            navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.photo), label: strings.home_screen_tab_photo),
          NavigationDestination(icon: const Icon(Icons.favorite), label: strings.home_screen_tab_favorite),
        ],
      ),
    );
  }
}
