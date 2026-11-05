import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/photo_failure.dart';
import '../../../l10n/app_localizations.dart';
import '../state/photo_state.dart';
import '../viewmodels/photo_viewmodel.dart';

@RoutePage()
class PhotoScreen extends ConsumerStatefulWidget {
  static const String routeName = 'photo';

  const PhotoScreen({super.key});

  @override
  ConsumerState<PhotoScreen> createState() => _PhotoScreenState();
}

class _PhotoScreenState extends ConsumerState<PhotoScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(photoViewModelProvider.notifier).fetchPhotos());
  }

  static String failureText(AppLocalizations strings, PhotoFailureKind kind) => switch (kind) {
    PhotoFailureKind.network => strings.photo_screen_failure_network,
    PhotoFailureKind.server => strings.photo_screen_failure_server,
    PhotoFailureKind.unknown => strings.photo_screen_failure_unknown,
  };

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final state = ref.watch(photoViewModelProvider);
    final viewModel = ref.read(photoViewModelProvider.notifier);

    // A failed next page keeps the grid and tells the user once, through a snack bar.
    ref.listen(photoViewModelProvider.select((state) => state.failure), (_, failure) {
      if (failure != null && ref.read(photoViewModelProvider).photos.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(failureText(strings, failure))));
      }
    });

    final Widget body = switch (state) {
      PhotoState(status: PhotoStatus.initial || PhotoStatus.loading) => const Center(
        child: CircularProgressIndicator(),
      ),
      PhotoState(status: PhotoStatus.failure, :final failure) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(failureText(strings, failure ?? PhotoFailureKind.unknown)),
            const SizedBox(height: 12),
            FilledButton(onPressed: viewModel.fetchPhotos, child: Text(strings.photo_screen_retry)),
          ],
        ),
      ),
      PhotoState(photos: final photos) when photos.isEmpty => Center(child: Text(strings.photo_screen_empty)),
      PhotoState(:final photos, :final status) => RefreshIndicator(
        onRefresh: viewModel.fetchPhotos,
        child: NotificationListener<ScrollEndNotification>(
          onNotification: (notification) {
            if (notification.metrics.extentAfter < 400) viewModel.fetchMorePhotos();
            return false;
          },
          child: GridView.builder(
            padding: const EdgeInsets.all(4),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemCount: photos.length + (status == PhotoStatus.fetchingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == photos.length) return const Center(child: CircularProgressIndicator());
              final photo = photos[index];
              return Semantics(
                image: true,
                label: photo.description,
                child: Image.network(photo.thumbUrl, fit: BoxFit.cover),
              );
            },
          ),
        ),
      ),
    };

    return Scaffold(
      appBar: AppBar(title: Text(strings.home_screen_tab_photo)),
      body: body,
    );
  }
}
