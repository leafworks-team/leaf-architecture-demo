import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../favorite/view/favorite_screen.dart';
import '../home/view/home_screen.dart';
import '../photo/view/photo_screen.dart';

part 'app_router.g.dart';

/// Every route path in the app. Screens navigate with these constants instead of string literals.
abstract final class Routes {
  static const photos = '/photos';
  static const favorites = '/favorites';
}

/// Rebuilding the router would throw away the navigation stack, so this provider is kept alive and never watches
/// another provider. A redirect that needs app state reads it with `ref.read`.
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final router = GoRouter(
    initialLocation: Routes.photos,
    routes: [
      // There is no screen at the root, so a link to it opens the first tab instead of the not-found page.
      GoRoute(path: '/', redirect: (context, state) => Routes.photos),
      // Each tab is a branch with its own navigator, so a tab keeps its stack while another tab is shown.
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => HomeScreen(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [GoRoute(path: Routes.photos, builder: (context, state) => const PhotoScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: Routes.favorites, builder: (context, state) => const FavoriteScreen())],
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
}
