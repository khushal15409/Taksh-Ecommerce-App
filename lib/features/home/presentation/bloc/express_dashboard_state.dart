import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/home/domain/entities/express_dashboard_entity.dart';

/// Base state for express dashboard
abstract class ExpressDashboardState extends Equatable {
  const ExpressDashboardState();

  @override
  List<Object?> get props => [];
}

class ExpressDashboardInitial extends ExpressDashboardState {
  const ExpressDashboardInitial();
}

class ExpressDashboardLoading extends ExpressDashboardState {
  const ExpressDashboardLoading();
}

class ExpressDashboardLoaded extends ExpressDashboardState {
  final ExpressDashboardEntity dashboard;

  const ExpressDashboardLoaded(this.dashboard);

  @override
  List<Object?> get props => [dashboard];
}

class ExpressDashboardRefreshing extends ExpressDashboardState {
  final ExpressDashboardEntity dashboard;

  const ExpressDashboardRefreshing(this.dashboard);

  @override
  List<Object?> get props => [dashboard];
}

class ExpressDashboardError extends ExpressDashboardState {
  final String message;

  const ExpressDashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
