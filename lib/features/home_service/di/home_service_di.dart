import 'package:get_it/get_it.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/features/home_service/data/datasources/home_service_remote_datasource.dart';
import 'package:taksh_e_commerce/features/home_service/data/repositories/home_service_repository_impl.dart';
import 'package:taksh_e_commerce/features/home_service/domain/repositories/home_service_repository.dart';
import 'package:taksh_e_commerce/features/home_service/domain/usecases/create_courier_booking.dart';
import 'package:taksh_e_commerce/features/home_service/domain/usecases/create_general_service_booking.dart';
import 'package:taksh_e_commerce/features/home_service/domain/usecases/get_courier_delivery_partners.dart';
import 'package:taksh_e_commerce/features/home_service/domain/usecases/get_courier_quote.dart';
import 'package:taksh_e_commerce/features/home_service/domain/usecases/get_service_inquiry_history.dart';
import 'package:taksh_e_commerce/features/home_service/domain/usecases/get_services.dart';
import 'package:taksh_e_commerce/features/home_service/presentation/cubit/home_service_cubit.dart';

/// Registers all dependencies for the Home Service feature.
void registerHomeServiceDependencies(GetIt getIt) {
  final log = loggerWithContext({
    'feature': 'home_service',
    'action': 'di_registration',
  });

  log.infoWithContext('Registering home service dependencies', {});

  // DataSource → lazySingleton
  getIt.registerLazySingleton<HomeServiceRemoteDataSource>(
    () => HomeServiceRemoteDataSourceImpl(getIt()),
  );

  // Repository → lazySingleton
  getIt.registerLazySingleton<HomeServiceRepository>(
    () => HomeServiceRepositoryImpl(getIt()),
  );

  // Use Cases → lazySingleton
  getIt.registerLazySingleton(() => GetServices(getIt()));
  getIt.registerLazySingleton(() => GetCourierDeliveryPartners(getIt()));
  getIt.registerLazySingleton(() => GetCourierQuote(getIt()));
  getIt.registerLazySingleton(() => CreateCourierBooking(getIt()));
  getIt.registerLazySingleton(() => CreateGeneralServiceBooking(getIt()));
  getIt.registerLazySingleton(() => GetServiceInquiryHistory(getIt()));

  // Cubit → factory (new instance per page)
  getIt.registerFactory(
    () => HomeServiceCubit(
      getServices: getIt(),
      getCourierDeliveryPartners: getIt(),
      getCourierQuote: getIt(),
      createCourierBooking: getIt(),
      createGeneralServiceBooking: getIt(),
      getServiceInquiryHistory: getIt(),
    ),
  );

  log.infoWithContext('Home service dependencies registered', {});
}
