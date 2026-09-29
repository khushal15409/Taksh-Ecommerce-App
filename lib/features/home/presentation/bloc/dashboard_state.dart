import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/home/domain/entities/dashboard_entity.dart';

/// Base class for dashboard states
abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any data is loaded
class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

/// State when dashboard data is being loaded
class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

/// State when dashboard data is loaded successfully
class DashboardLoaded extends DashboardState {
  final DashboardEntity dashboard;

  const DashboardLoaded(this.dashboard);

  @override
  List<Object?> get props => [dashboard];
}

/// State when refreshing dashboard data (shows existing data while refreshing)
class DashboardRefreshing extends DashboardState {
  final DashboardEntity dashboard;

  const DashboardRefreshing(this.dashboard);

  @override
  List<Object?> get props => [dashboard];
}

/// State when dashboard loading fails
class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
