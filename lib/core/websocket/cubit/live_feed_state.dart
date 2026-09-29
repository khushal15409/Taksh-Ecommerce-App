import 'package:equatable/equatable.dart';

/// Base state for any cubit backed by a live WebSocket feed.
///
/// [T] is the feature-specific data type delivered in each frame.
/// Use sealed classes so the compiler enforces exhaustive pattern-matching.
sealed class LiveFeedState<T> extends Equatable {
  const LiveFeedState();

  @override
  List<Object?> get props => [];
}

/// Initial — [connect] has not been called yet.
final class LiveFeedInitial<T> extends LiveFeedState<T> {
  const LiveFeedInitial();
}

/// A connection attempt is in progress.
final class LiveFeedConnecting<T> extends LiveFeedState<T> {
  const LiveFeedConnecting();
}

/// Socket is open; waiting for the first data frame.
final class LiveFeedConnected<T> extends LiveFeedState<T> {
  const LiveFeedConnected();
}

/// A parsed data frame has been received.
///
/// [data] is the latest payload.
/// [previousData] is the immediately prior payload — useful for animated
/// diffs in the UI without keeping a separate history list.
final class LiveFeedData<T> extends LiveFeedState<T> {
  final T data;
  final T? previousData;

  const LiveFeedData({required this.data, this.previousData});

  @override
  List<Object?> get props => [data, previousData];

  @override
  String toString() => 'LiveFeedData(data: $data)';
}

/// The socket is disconnected (may reconnect automatically).
final class LiveFeedDisconnected<T> extends LiveFeedState<T> {
  /// Last received payload preserved so the UI can show stale data.
  final T? lastData;
  final String? reason;

  const LiveFeedDisconnected({this.lastData, this.reason});

  @override
  List<Object?> get props => [lastData, reason];

  @override
  String toString() =>
      'LiveFeedDisconnected(reason: $reason, hasLastData: ${lastData != null})';
}

/// Automatic reconnection is in progress.
final class LiveFeedReconnecting<T> extends LiveFeedState<T> {
  final int attempt;
  final Duration nextDelay;

  /// Last received payload preserved so the UI can continue displaying data.
  final T? lastData;

  const LiveFeedReconnecting({
    required this.attempt,
    required this.nextDelay,
    this.lastData,
  });

  @override
  List<Object?> get props => [attempt, nextDelay, lastData];

  @override
  String toString() =>
      'LiveFeedReconnecting(attempt: $attempt, nextDelay: $nextDelay)';
}

/// A terminal or non-recoverable error.
final class LiveFeedError<T> extends LiveFeedState<T> {
  final String message;
  final Object? error;

  /// Last received payload preserved so the UI can show stale data.
  final T? lastData;

  const LiveFeedError({
    required this.message,
    this.error,
    this.lastData,
  });

  @override
  List<Object?> get props => [message, error, lastData];

  @override
  String toString() => 'LiveFeedError(message: $message)';
}
