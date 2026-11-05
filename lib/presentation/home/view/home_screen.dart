import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../core/router/app_router.gr.dart';
import '../../../l10n/app_localizations.dart';

/// Tab container. It holds no state of its own, so it needs no view model.
@RoutePage()
class HomeScreen extends StatelessWidget {
  static const String routeName = '/';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return AutoTabsRouter(
      routes: const [PhotoRoute(), FavoriteRoute()],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          body: child,
          bottomNavigationBar: NavigationBar(
            selectedIndex: tabsRouter.activeIndex,
            onDestinationSelected: tabsRouter.setActiveIndex,
            destinations: [
              NavigationDestination(icon: const Icon(Icons.photo), label: strings.home_screen_tab_photo),
              NavigationDestination(icon: const Icon(Icons.favorite), label: strings.home_screen_tab_favorite),
            ],
          ),
        );
      },
    );
  }
}
