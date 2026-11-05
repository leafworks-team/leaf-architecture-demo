import 'package:injectable/injectable.dart';
import 'package:leaf_architecture/leaf_architecture.dart';

import 'injection.config.dart';

/// GetIt holds infrastructure only (StorageService and friends). Everything used inside the widget tree goes
/// through Riverpod. Injectable does not scan dependencies, so leaf_architecture is registered as a micro package.
@InjectableInit(externalPackageModulesBefore: [ExternalModule(LeafArchitecturePackageModule)])
Future<void> configureDependencies() async => getIt.init();
