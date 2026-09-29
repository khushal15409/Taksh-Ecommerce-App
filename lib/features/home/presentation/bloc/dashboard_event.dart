import 'package:equatable/equatable.dart';

/// Base class for dashboard events
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load dashboard data
class DashboardLoadRequested extends DashboardEvent {
  final double latitude;
  final double longitude;

  const DashboardLoadRequested({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [latitude, longitude];
}

/// Event to refresh dashboard data
class DashboardRefreshRequested extends DashboardEvent {
  final double latitude;
  final double longitude;

  const DashboardRefreshRequested({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [latitude, longitude];
}
