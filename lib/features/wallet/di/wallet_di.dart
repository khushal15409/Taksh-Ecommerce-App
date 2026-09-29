import 'package:get_it/get_it.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/features/wallet/data/datasources/wallet_remote_datasource.dart';
import 'package:taksh_e_commerce/features/wallet/data/repositories/wallet_repository_impl.dart';
import 'package:taksh_e_commerce/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:taksh_e_commerce/features/wallet/domain/usecases/get_bank_accounts.dart';
import 'package:taksh_e_commerce/features/wallet/domain/usecases/get_wallet_summary.dart';
import 'package:taksh_e_commerce/features/wallet/domain/usecases/request_withdrawal.dart';
import 'package:taksh_e_commerce/features/wallet/presentation/cubit/wallet_cubit.dart';

/// Register all wallet feature dependencies
void registerWalletDependencies(GetIt getIt) {
  final log = loggerWithContext({'feature': 'di', 'layer': 'wallet'});

  log.debugWithContext('Registering wallet dependencies', {'action': 'start'});

  // Data source
  getIt.registerLazySingleton<WalletRemoteDataSource>(
    () => WalletRemoteDataSourceImpl(apiClient: getIt()),
  );

  // Repository
  getIt.registerLazySingleton<WalletRepository>(
    () => WalletRepositoryImpl(remoteDataSource: getIt()),
  );

  // Use cases
  getIt.registerLazySingleton(() => GetWalletSummary(getIt()));
  getIt.registerLazySingleton(() => RequestWithdrawal(getIt()));
  getIt.registerLazySingleton(() => GetBankAccounts(getIt()));

  // Cubit — factory so each screen gets a fresh instance
  getIt.registerFactory(
    () => WalletCubit(
      getWalletSummary: getIt(),
      requestWithdrawal: getIt(),
      getBankAccounts: getIt(),
    ),
  );

  log.debugWithContext(
    'Wallet dependencies registered',
    {'datasources': 1, 'usecases': 3, 'cubits': 1},
  );
}
