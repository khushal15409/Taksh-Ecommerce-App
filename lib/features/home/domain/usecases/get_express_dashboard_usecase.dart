import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/home/domain/entities/express_dashboard_entity.dart';
import 'package:taksh_e_commerce/features/home/domain/repositories/express_dashboard_repository.dart';

/// Use case for fetching express dashboard data
class GetExpressDashboardUseCase
    extends UseCase<ExpressDashboardEntity, ExpressDashboardParams> {
  final ExpressDashboardRepository _repository;

  const GetExpressDashboardUseCase(this._repository);

  @override
  ResultFuture<ExpressDashboardEntity> call(ExpressDashboardParams params) {
    return _repository.getExpressDashboard(
      latitude: params.latitude,
      longitude: params.longitude,
      pincode: params.pincode,
    );
  }
}

/// Parameters for express dashboard
class ExpressDashboardParams extends Equatable {
  final double latitude;
  final double longitude;
  final String pincode;

  const ExpressDashboardParams({
    required this.latitude,
    required this.longitude,
    required this.pincode,
  });

  @override
  List<Object?> get props => [latitude, longitude, pincode];
}
