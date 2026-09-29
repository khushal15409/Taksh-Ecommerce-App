import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/home/domain/entities/dashboard_entity.dart';
import 'package:taksh_e_commerce/features/home/domain/repositories/dashboard_repository.dart';

/// Use case for fetching dashboard data
class GetDashboardUseCase extends UseCase<DashboardEntity, DashboardParams> {
  final DashboardRepository _repository;

  const GetDashboardUseCase(this._repository);

  @override
  ResultFuture<DashboardEntity> call(DashboardParams params) {
    return _repository.getDashboard(
      latitude: params.latitude,
      longitude: params.longitude,
    );
  }
}

/// Parameters for GetDashboardUseCase
class DashboardParams extends Equatable {
  final double latitude;
  final double longitude;

  const DashboardParams({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [latitude, longitude];
}
