import 'network_info.dart';

/// Simple implementation of NetworkInfo
/// 
/// This is a basic implementation that always returns true (assumes online).
/// In production, this would use connectivity_plus or similar package
/// to check actual network connectivity.
class NetworkInfoImpl implements NetworkInfo {
  bool _isConnected = true;

  /// Set the connection status (useful for testing)
  void setConnected(bool connected) {
    _isConnected = connected;
  }

  @override
  Future<bool> get isConnected async => _isConnected;
}

