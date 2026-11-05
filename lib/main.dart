import 'package:architecture_sample/core/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leaf_architecture/leaf_architecture.dart';
import 'package:architecture_sample/l10n/app_localizations.dart';

import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Storage opens asynchronously, so open it before runApp and hand it to Riverpod.
  final storage = await StorageService.open();
  runApp(
    ProviderScope(overrides: [storageServiceProvider.overrideWithValue(storage)], child: const ArchitectureSampleApp()),
  );
}

class ArchitectureSampleApp extends ConsumerWidget {
  const ArchitectureSampleApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context)?.app_title ?? 'Flutter Architecture Sample',
      theme: AppTheme.lightTheme,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('en'), Locale('ja'), Locale('ko')],
      darkTheme: AppTheme.darkTheme,
      routerConfig: ref.read(appRouterProvider).config(),
    );
  }
}
