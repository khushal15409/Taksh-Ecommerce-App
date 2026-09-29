import 'package:get_it/get_it.dart';
import 'package:taksh_e_commerce/features/payment/data/datasources/payment_mock_datasource.dart';
import 'package:taksh_e_commerce/features/payment/data/datasources/payment_remote_datasource.dart';
import 'package:taksh_e_commerce/features/payment/data/datasources/payment_remote_datasource_impl.dart';
import 'package:taksh_e_commerce/features/payment/data/repositories/payment_repository_impl.dart';
import 'package:taksh_e_commerce/features/payment/domain/repositories/payment_repository.dart';
import 'package:taksh_e_commerce/features/payment/domain/usecases/create_razorpay_order.dart';
import 'package:taksh_e_commerce/features/payment/domain/usecases/get_payment_history.dart';
import 'package:taksh_e_commerce/features/payment/domain/usecases/initiate_payment.dart';
import 'package:taksh_e_commerce/features/payment/domain/usecases/save_payment.dart';
import 'package:taksh_e_commerce/features/payment/domain/usecases/verify_payment.dart';
import 'package:taksh_e_commerce/features/payment/domain/usecases/verify_payment_usecase.dart';
import 'package:taksh_e_commerce/features/payment/presentation/bloc/payment_bloc.dart';

/// Register payment feature dependencies
void registerPaymentDependencies(GetIt getIt, {bool useMockData = false}) {
  // Data sources
  if (useMockData) {
    getIt.registerLazySingleton<PaymentRemoteDataSource>(
      () => PaymentMockDataSource(),
    );
  } else {
    // Register real data source
    getIt.registerLazySingleton<PaymentRemoteDataSource>(
      () => PaymentRemoteDataSourceImpl(apiClient: getIt()),
    );
  }

  // Repository
  getIt.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(
      remoteDataSource: getIt<PaymentRemoteDataSource>(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(() => CreateRazorpayOrder(getIt()));
  getIt.registerLazySingleton(() => VerifyPayment(getIt()));
  getIt.registerLazySingleton(() => SavePayment(getIt()));
  getIt.registerLazySingleton(() => GetPaymentHistory(getIt()));
  getIt.registerLazySingleton(() => InitiatePayment(getIt()));
  getIt.registerLazySingleton(() => VerifyPaymentUseCase(getIt()));

  // BLoC
  getIt.registerFactory(
    () => PaymentBloc(
      createRazorpayOrder: getIt<CreateRazorpayOrder>(),
      verifyPayment: getIt<VerifyPayment>(),
      savePayment: getIt<SavePayment>(),
    ),
  );
}
