import 'package:get_it/get_it.dart';
import 'package:taksh_e_commerce/features/checkout/data/datasources/checkout_mock_datasource.dart';
import 'package:taksh_e_commerce/features/checkout/data/datasources/checkout_remote_datasource.dart';
import 'package:taksh_e_commerce/features/checkout/data/datasources/checkout_remote_datasource_impl.dart';
import 'package:taksh_e_commerce/features/checkout/data/repositories/checkout_repository_impl.dart';
import 'package:taksh_e_commerce/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:taksh_e_commerce/features/checkout/domain/usecases/calculate_checkout.dart';
import 'package:taksh_e_commerce/features/checkout/domain/usecases/create_order.dart';
import 'package:taksh_e_commerce/features/checkout/domain/usecases/get_delivery_options.dart';
import 'package:taksh_e_commerce/features/checkout/domain/usecases/place_order.dart';
import 'package:taksh_e_commerce/features/checkout/domain/usecases/validate_checkout.dart';
import 'package:taksh_e_commerce/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:taksh_e_commerce/features/payment/domain/usecases/initiate_payment.dart';
import 'package:taksh_e_commerce/features/payment/domain/usecases/verify_payment_usecase.dart';
import 'package:taksh_e_commerce/features/product/domain/usecases/check_delivery_availability.dart';

/// Register checkout feature dependencies
void registerCheckoutDependencies(GetIt getIt, {bool useMockData = false}) {
  // Data sources
  if (useMockData) {
    getIt.registerLazySingleton<CheckoutRemoteDataSource>(
      () => CheckoutMockDataSource(),
    );
  } else {
    // Register real data source
    getIt.registerLazySingleton<CheckoutRemoteDataSource>(
      () => CheckoutRemoteDataSourceImpl(apiClient: getIt()),
    );
  }

  // Repository
  getIt.registerLazySingleton<CheckoutRepository>(
    () => CheckoutRepositoryImpl(
      remoteDataSource: getIt<CheckoutRemoteDataSource>(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(() => CalculateCheckout(getIt()));
  getIt.registerLazySingleton(() => GetDeliveryOptions(getIt()));
  getIt.registerLazySingleton(() => ValidateCheckout(getIt()));
  getIt.registerLazySingleton(() => CreateOrder(getIt()));
  getIt.registerLazySingleton(() => PlaceOrder(getIt()));

  // BLoC
  // NOTE: CheckDeliveryAvailability is registered in the product DI module
  // (see lib/core/di/injector.dart → _registerProductDependencies).
  // It is injected here as a cross-feature dependency.
  getIt.registerFactory(
    () => CheckoutBloc(
      calculateCheckout: getIt<CalculateCheckout>(),
      getDeliveryOptions: getIt<GetDeliveryOptions>(),
      validateCheckout: getIt<ValidateCheckout>(),
      createOrder: getIt<CreateOrder>(),
      placeOrder: getIt<PlaceOrder>(),
      initiatePayment: getIt<InitiatePayment>(),
      verifyPayment: getIt<VerifyPaymentUseCase>(),
      checkDeliveryAvailability: getIt<CheckDeliveryAvailability>(),
    ),
  );
}
