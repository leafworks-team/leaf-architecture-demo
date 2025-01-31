import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class FavoriteScreen extends ConsumerWidget {
  static const String routeName = 'favorite';

  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(color: Colors.red),
    );
  }
}
