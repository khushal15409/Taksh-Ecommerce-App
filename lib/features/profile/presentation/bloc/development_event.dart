import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/profile/domain/entities/development_request.dart';

/// Base class for development events
abstract class DevelopmentEvent extends Equatable {
  const DevelopmentEvent();

  @override
  List<Object?> get props => [];
}

/// Event to submit development request
class DevelopmentRequestSubmitted extends DevelopmentEvent {
  final DevelopmentRequest request;

  const DevelopmentRequestSubmitted({required this.request});

  @override
  List<Object?> get props => [request];
}
