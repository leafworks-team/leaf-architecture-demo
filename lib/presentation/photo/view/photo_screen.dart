import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodels/photo_viewmodel.dart';

@RoutePage()
class PhotoScreen extends ConsumerWidget {
  static const String routeName = 'photo';

  const PhotoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photoState = ref.watch(photoViewModelProvider);
    final photoViewModel = ref.read(photoViewModelProvider.notifier);

    return Scaffold();
  }
}
