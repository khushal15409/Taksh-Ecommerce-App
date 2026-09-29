import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/profile/domain/entities/callback_response.dart';

/// Base class for callback states
abstract class CallbackState extends Equatable {
  const CallbackState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class CallbackInitial extends CallbackState {
  const CallbackInitial();
}

/// Loading state
class CallbackLoading extends CallbackState {
  const CallbackLoading();
}

/// Success state
class CallbackRequestSuccess extends CallbackState {
  final CallbackResponse response;
  final String message;

  const CallbackRequestSuccess({
    required this.response,
    required this.message,
  });

  @override
  List<Object?> get props => [response, message];
}

/// Error state
class CallbackError extends CallbackState {
  final String message;

  const CallbackError({required this.message});

  @override
  List<Object?> get props => [message];
}
