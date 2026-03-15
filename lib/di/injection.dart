import 'package:leaf_architecture/leaf_architecture.dart';
import 'package:injectable/injectable.dart';
import 'injection.config.dart';

@InjectableInit()
Future<void> configureDependencies() async => getIt.init();
