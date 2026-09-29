import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:taksh_e_commerce/core/utils/secure_store.dart';

/// Register secure storage helper in DI
void registerSecureStore(GetIt getIt) {
  getIt.registerLazySingleton<SecureStore>(
    () => SecureStoreImpl(storage: const FlutterSecureStorage()),
  );
}
