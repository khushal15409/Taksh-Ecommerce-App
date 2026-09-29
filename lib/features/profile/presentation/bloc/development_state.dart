import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/profile/domain/entities/development_response.dart';

/// Base class for development states
abstract class DevelopmentState extends Equatable {
  const DevelopmentState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class DevelopmentInitial extends DevelopmentState {
  const DevelopmentInitial();
}

/// Loading state
class DevelopmentLoading extends DevelopmentState {
  const DevelopmentLoading();
}

/// Success state
class DevelopmentRequestSuccess extends DevelopmentState {
  final DevelopmentResponse response;
  final String message;

  const DevelopmentRequestSuccess({
    required this.response,
    required this.message,
  });

  @override
  List<Object?> get props => [response, message];
}

/// Error state
class DevelopmentError extends DevelopmentState {
  final String message;

  const DevelopmentError({required this.message});

  @override
  List<Object?> get props => [message];
}
