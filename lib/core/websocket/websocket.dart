/// WebSocket module — barrel export.
///
/// Import this single file in feature code:
/// ```dart
/// import 'package:taksh_e_commerce/core/websocket/websocket.dart';
/// ```
library;

// Config
export 'config/websocket_config.dart';

// Models
export 'models/websocket_connection_state.dart';
export 'models/websocket_message.dart';

// Service
export 'service/websocket_service.dart';
export 'service/websocket_service_impl.dart';

// Manager
export 'manager/websocket_manager.dart';

// Cubit
export 'cubit/live_feed_cubit.dart';
export 'cubit/live_feed_state.dart';

// Exceptions / Failures
export 'exceptions/websocket_exceptions.dart';

// DI
export 'di/websocket_di.dart';
