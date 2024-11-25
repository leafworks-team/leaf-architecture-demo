import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeViewModelProvider =
    StateNotifierProvider<HomeViewModel, void>((ref) {
      return HomeViewModel(ref);
    });

class HomeViewModel extends StateNotifier<void> {
  HomeViewModel(super.state);
}