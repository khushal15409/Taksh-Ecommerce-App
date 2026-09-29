import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';

// Domain layer
import 'package:taksh_e_commerce/features/address/domain/repositories/address_repository.dart';
import 'package:taksh_e_commerce/features/address/domain/usecases/add_address.dart';
import 'package:taksh_e_commerce/features/address/domain/usecases/delete_address.dart';
import 'package:taksh_e_commerce/features/address/domain/usecases/get_addresses.dart';
import 'package:taksh_e_commerce/features/address/domain/usecases/get_current_location.dart';
import 'package:taksh_e_commerce/features/address/domain/usecases/get_location_from_latlng.dart';
import 'package:taksh_e_commerce/features/address/domain/usecases/search_places.dart';
import 'package:taksh_e_commerce/features/address/domain/usecases/set_default_address.dart';
import 'package:taksh_e_commerce/features/address/domain/usecases/update_address.dart';

// Data layer
import 'package:taksh_e_commerce/features/address/data/datasources/address_local_datasource.dart';
import 'package:taksh_e_commerce/features/address/data/datasources/address_remote_datasource.dart';
import 'package:taksh_e_commerce/features/address/data/models/address_model.dart';
import 'package:taksh_e_commerce/features/address/data/models/location_model.dart';
import 'package:taksh_e_commerce/features/address/data/repositories/address_repository_impl.dart';
import 'package:taksh_e_commerce/features/address/data/repositories/mock_address_repository.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/address_type.dart';

// Presentation layer
import 'package:taksh_e_commerce/features/address/presentation/bloc/address_bloc.dart';
import 'package:taksh_e_commerce/features/address/presentation/cubit/map_cubit.dart';

/// Register address feature dependencies
void registerAddressDependencies(GetIt getIt, {bool useMock = false}) {
  final log = loggerWithContext({'feature': 'di', 'layer': 'address'});

  log.debugWithContext('Registering address dependencies', {'action': 'start'});

  // Register Hive adapters
  if (!Hive.isAdapterRegistered(10)) {
    Hive.registerAdapter(AddressTypeAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(AddressModelAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(LocationModelAdapter());
  }

  // Data sources
  if (!useMock) {
    // Remote data source
    getIt.registerLazySingleton<AddressRemoteDataSource>(
      () => AddressRemoteDataSourceImpl(apiClient: getIt()),
    );

    // Local data source
    getIt.registerLazySingleton<AddressLocalDataSource>(
      () => AddressLocalDataSourceImpl(hive: Hive),
    );

    // Repository - Real implementation
    getIt.registerLazySingleton<AddressRepository>(
      () => AddressRepositoryImpl(
        remoteDataSource: getIt(),
        localDataSource: getIt(),
        networkInfo: getIt(),
      ),
    );
  } else {
    // Repository - Mock implementation for testing
    getIt.registerLazySingleton<AddressRepository>(
      () => MockAddressRepository(),
    );
  }

  // Use cases
  getIt.registerLazySingleton(() => GetAddresses(getIt()));
  getIt.registerLazySingleton(() => AddAddress(getIt()));
  getIt.registerLazySingleton(() => UpdateAddress(getIt()));
  getIt.registerLazySingleton(() => DeleteAddress(getIt()));
  getIt.registerLazySingleton(() => SetDefaultAddress(getIt()));
  getIt.registerLazySingleton(() => GetCurrentLocation(getIt()));
  getIt.registerLazySingleton(() => SearchPlaces(getIt()));
  getIt.registerLazySingleton(() => GetLocationFromLatLng(getIt()));

  // BLoC - factory (new instance each time)
  getIt.registerFactory(
    () => AddressBloc(
      getAddresses: getIt(),
      addAddress: getIt(),
      updateAddress: getIt(),
      deleteAddress: getIt(),
      setDefaultAddress: getIt(),
    ),
  );

  // Map Cubit - factory (new instance each time)
  getIt.registerFactory(
    () => MapCubit(
      getCurrentLocation: getIt(),
      searchPlaces: getIt(),
      getLocationFromLatLng: getIt(),
    ),
  );

  log.debugWithContext(
    'Address dependencies registered',
    {'usecases': 8, 'blocs': 1, 'cubits': 1},
  );
}
