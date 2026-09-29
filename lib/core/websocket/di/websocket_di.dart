import 'package:get_it/get_it.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/core/websocket/config/websocket_config.dart';
import 'package:taksh_e_commerce/core/websocket/manager/websocket_manager.dart';
import 'package:taksh_e_commerce/core/websocket/service/websocket_service.dart';
import 'package:taksh_e_commerce/core/websocket/service/websocket_service_impl.dart';

/// Registers the WebSocket infrastructure in the service locator.
///
/// **What gets registered:**
///
/// | Type | Scope | Notes |
/// |---|---|---|
/// | [WebSocketManagerFactory] | lazy singleton | Creates new [WebSocketManager] instances on demand |
///
/// **What is NOT registered here:**
/// - Feature-specific cubits that extend [LiveFeedCubit].  Those are
///   registered inside their own feature DI modules, calling
///   [WebSocketManagerFactory.create] with the appropriate config.
void registerWebSocketDependencies(GetIt getIt) {
  final log = loggerWithContext({'feature': 'di', 'layer': 'websocket'});
  log.debugWithContext('Registering WebSocket dependencies', {});

  // Register the factory as a lazy singleton so the same factory instance is
  // reused across the app.  Individual managers (one per feature) are created
  // on demand via the factory.
  getIt.registerLazySingleton<WebSocketManagerFactory>(
    () => const WebSocketManagerFactory(),
  );

  log.debugWithContext('WebSocket dependencies registered', {});
}

/// Creates [WebSocketManager] instances, each backed by an independent
/// [WebSocketService], for a given [WebSocketConfig].
///
/// Use one manager per logical channel / endpoint.  Inject via GetIt:
/// ```dart
/// final manager = getIt<WebSocketManagerFactory>().create(config);
/// ```
class WebSocketManagerFactory {
  const WebSocketManagerFactory();

  /// Creates a new [WebSocketManager] with its own [WebSocketService].
  ///
  /// The caller (usually a feature DI module) is responsible for disposing
  /// the manager when the feature is no longer needed.
  WebSocketManager create(WebSocketConfig config) {
    return WebSocketManager(
      service: WebSocketServiceImpl(),
      config: config,
    );
  }

  /// Convenience factory for test/mock environments where you want to supply
  /// a custom [WebSocketService] (e.g. a fake or mock).
  WebSocketManager createWithService({
    required WebSocketService service,
    required WebSocketConfig config,
  }) {
    return WebSocketManager(service: service, config: config);
  }
}
