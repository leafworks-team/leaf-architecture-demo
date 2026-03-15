import 'package:architecture_sample/core/router/app_router.gr.dart';
import 'package:architecture_sample/presentation/home/viewmodels/home_viewmodel.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:architecture_sample/l10n/app_localizations.dart';

@RoutePage()
class HomeScreen extends ConsumerStatefulWidget {
  static const String routeName = '/';

  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeViewModelProvider);
    final homeViewModel = ref.read(homeViewModelProvider.notifier);

    return AutoTabsRouter.tabBar(
      routes: [
        PhotoRoute(),
        FavoriteRoute(),
      ],
      builder: (context, child, controller) {
        final tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          body: child,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: tabsRouter.activeIndex,
            onTap: tabsRouter.setActiveIndex,
            items: [
              BottomNavigationBarItem(
                  icon: const Icon(Icons.photo),
                  label: AppLocalizations.of(context)!.home_screen_tab_photo),
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  label:
                      AppLocalizations.of(context)!.home_screen_tab_favorite),
            ],
          ),
        );
      },
    );
  }
}
