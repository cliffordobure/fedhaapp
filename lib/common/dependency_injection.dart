import 'package:get_it/get_it.dart';
import 'package:fedha/localization/app_prefs.dart';

final GetIt getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerLazySingleton<AppPreferences>(() => AppPreferences());
// Register other dependencies here
}
