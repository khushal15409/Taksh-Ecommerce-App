import 'package:get_it/get_it.dart';
import 'package:taksh_e_commerce/features/product/domain/usecases/get_express_products.dart';
import 'package:taksh_e_commerce/features/quick_delivery/data/datasources/quick_delivery_remote_datasource.dart';
import 'package:taksh_e_commerce/features/quick_delivery/data/repositories/quick_delivery_repository_impl.dart';
import 'package:taksh_e_commerce/features/quick_delivery/domain/repositories/quick_delivery_repository.dart';
import 'package:taksh_e_commerce/features/quick_delivery/domain/usecases/get_quick_delivery_location.dart';
import 'package:taksh_e_commerce/features/quick_delivery/presentation/cubit/express_products_cubit.dart';
import 'package:taksh_e_commerce/features/quick_delivery/presentation/cubit/quick_delivery_tracking_cubit.dart';

void registerQuickDeliveryDependencies(GetIt getIt) {
  getIt.registerLazySingleton<QuickDeliveryRemoteDatasource>(
    () => QuickDeliveryRemoteDatasourceImpl(getIt()),
  );

  getIt.registerLazySingleton<QuickDeliveryRepository>(
    () => QuickDeliveryRepositoryImpl(getIt()),
  );

  getIt.registerLazySingleton(() => GetQuickDeliveryLocation(getIt()));
  getIt.registerLazySingleton(() => GetExpressProducts(getIt()));

  getIt.registerFactory(
    () => QuickDeliveryTrackingCubit(
      getQuickDeliveryLocation: getIt(),
    ),
  );

  getIt.registerFactory(
    () => ExpressProductsCubit(
      getExpressProducts: getIt(),
    ),
  );
}
