import 'package:equatable/equatable.dart';

/// Base class for express dashboard events
abstract class ExpressDashboardEvent extends Equatable {
  const ExpressDashboardEvent();

  @override
  List<Object?> get props => [];
}

class ExpressDashboardLoadRequested extends ExpressDashboardEvent {
  final double latitude;
  final double longitude;
  final String pincode;

  const ExpressDashboardLoadRequested({
    required this.latitude,
    required this.longitude,
    required this.pincode,
  });

  @override
  List<Object?> get props => [latitude, longitude, pincode];
}

class ExpressDashboardRefreshRequested extends ExpressDashboardEvent {
  final double latitude;
  final double longitude;
  final String pincode;

  const ExpressDashboardRefreshRequested({
    required this.latitude,
    required this.longitude,
    required this.pincode,
  });

  @override
  List<Object?> get props => [latitude, longitude, pincode];
}
