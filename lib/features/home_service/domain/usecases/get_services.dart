import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/home_service/domain/entities/home_service.dart';
import 'package:taksh_e_commerce/features/home_service/domain/repositories/home_service_repository.dart';

/// Fetches all available home services.
class GetServices implements UseCaseNoParams<List<HomeService>> {
  final HomeServiceRepository repository;

  const GetServices(this.repository);

  @override
  ResultFuture<List<HomeService>> call() async {
    return repository.getServices();
  }
}
