
import 'package:get_it/get_it.dart';
import 'package:sos_driver_app/remote/api_client.dart';
import 'package:sos_driver_app/utils/app_notification.dart';
import 'package:sos_driver_app/utils/shared_prefs.dart';

GetIt locator = GetIt.instance;

void setUpInjector() {
  locator.registerLazySingleton(() => SharedPrefs());
  locator.registerLazySingleton(() => ApiClient());
  locator.registerLazySingleton(() => AppNotification());
}
