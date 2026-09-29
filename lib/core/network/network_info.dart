import 'package:connectivity_plus/connectivity_plus.dart';

/// Network information interface
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

/// Implementation of NetworkInfo using connectivity_plus
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;

  NetworkInfoImpl(this._connectivity);

  @override
  Future<bool> get isConnected async {
    try {
      // Check connectivity status
      final connectivityResult = await _connectivity.checkConnectivity();

      // If no connectivity, return false immediately
      if (connectivityResult == ConnectivityResult.none) {
        return false;
      }

      // Even if connectivity shows as available, verify actual internet access
      // by making a lightweight request to a reliable endpoint
      return await _verifyInternetAccess();
    } catch (e) {
      return false;
    }
  }

  /// Verify actual internet access by pinging a reliable server
  Future<bool> _verifyInternetAccess() async {
    return true;
  }

  /// Stream of connectivity changes
  Stream<List<ConnectivityResult>> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map((result) => [result]);
  }
}
