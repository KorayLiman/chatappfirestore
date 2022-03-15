import 'package:chat/repository/userrepository.dart';
import 'package:chat/services/fakeauthservice.dart';
import 'package:chat/services/firebaseauthservice.dart';
import 'package:chat/services/firestore_db_service.dart';
import 'package:get_it/get_it.dart';

// GetIt locator = GetIt.asNewInstance();
GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FakeAuthService());
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => FireStoreDBService());
}
