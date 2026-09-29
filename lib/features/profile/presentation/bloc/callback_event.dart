import 'package:equatable/equatable.dart';

/// Base class for callback events
abstract class CallbackEvent extends Equatable {
  const CallbackEvent();

  @override
  List<Object?> get props => [];
}

/// Event to request callback
class CallbackRequested extends CallbackEvent {
  const CallbackRequested();
}
