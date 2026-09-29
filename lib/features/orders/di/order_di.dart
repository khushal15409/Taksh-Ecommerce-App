import 'package:get_it/get_it.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';

// Domain layer
import 'package:taksh_e_commerce/features/orders/domain/repositories/order_repository.dart';
import 'package:taksh_e_commerce/features/orders/domain/usecases/cancel_order.dart';
import 'package:taksh_e_commerce/features/orders/domain/usecases/download_invoice.dart';
import 'package:taksh_e_commerce/features/orders/domain/usecases/get_orders.dart';
import 'package:taksh_e_commerce/features/orders/domain/usecases/get_order_details.dart';
import 'package:taksh_e_commerce/features/orders/domain/usecases/place_order.dart';
import 'package:taksh_e_commerce/features/orders/domain/usecases/request_return.dart';
import 'package:taksh_e_commerce/features/orders/domain/usecases/upload_return_media.dart';

// Data layer
import 'package:taksh_e_commerce/features/orders/data/datasources/order_remote_datasource.dart';
import 'package:taksh_e_commerce/features/orders/data/repositories/order_repository_impl.dart';

// Presentation layer
import 'package:taksh_e_commerce/features/orders/presentation/cubit/orders_cubit.dart';

/// Register order feature dependencies
void registerOrderDependencies(GetIt getIt) {
  final log = loggerWithContext({'feature': 'di', 'layer': 'orders'});

  log.debugWithContext('Registering order dependencies', {'action': 'start'});

  // Data sources
  getIt.registerLazySingleton<OrderRemoteDatasource>(
    () => OrderRemoteDatasourceImpl(getIt()),
  );

  // Repository
  getIt.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(getIt()),
  );

  // Use cases
  getIt.registerLazySingleton(() => GetOrders(getIt()));
  getIt.registerLazySingleton(() => GetOrderDetails(getIt()));
  getIt.registerLazySingleton(() => PlaceOrder(getIt()));
  getIt.registerLazySingleton(() => RequestReturn(getIt()));
  getIt.registerLazySingleton(() => UploadReturnMedia(getIt()));
  getIt.registerLazySingleton(() => CancelOrder(getIt()));
  getIt.registerLazySingleton(() => DownloadInvoice(getIt()));

  // Cubit - factory (new instance each time)
  getIt.registerFactory(
    () => OrdersCubit(
      getOrders: getIt(),
      getOrderDetails: getIt(),
      placeOrder: getIt(),
      requestReturn: getIt(),
      uploadReturnMedia: getIt(),
      cancelOrderUsecase: getIt(),
      downloadInvoiceUsecase: getIt(),
    ),
  );

  log.debugWithContext(
    'Order dependencies registered',
    {'usecases': 6, 'datasources': 1, 'repositories': 1, 'cubits': 1},
  );
}
