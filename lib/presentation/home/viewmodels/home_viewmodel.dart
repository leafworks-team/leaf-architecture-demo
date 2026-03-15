import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../state/home_state.dart';

part 'home_viewmodel.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  HomeState build() => HomeState();
}
