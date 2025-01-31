import 'package:architecture_sample/core/router/app_router.gr.dart';
import 'package:architecture_sample/presentation/favorite/view/favorite_screen.dart';
import 'package:architecture_sample/presentation/home/view/home_screen.dart';
import 'package:architecture_sample/presentation/photo/view/photo_screen.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appRouterProvider = Provider((ref) => AppRouter());

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: HomeRoute.page,
          path: HomeScreen.routeName,
          initial: true,
          children: [
            AutoRoute(
              page: PhotoRoute.page,
              path: PhotoScreen.routeName,
            ),
            AutoRoute(
              page: FavoriteRoute.page,
              path: FavoriteScreen.routeName,
            ),
          ],
        ),
      ];

  @override
  List<AutoRouteGuard> get guards => [];
}
