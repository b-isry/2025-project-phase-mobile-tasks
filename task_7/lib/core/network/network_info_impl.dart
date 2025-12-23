import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'network_info.dart';

/// Concrete implementation of NetworkInfo using InternetConnectionChecker
/// 
/// This implementation checks actual internet connectivity by attempting
/// to reach internet servers, not just checking network interface status.
/// 
/// On web platforms, this always returns true since InternetConnectionChecker
/// uses raw sockets which are not supported in browsers.
class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker? connectionChecker;

  /// Creates a NetworkInfoImpl with an optional InternetConnectionChecker instance
  /// 
  /// Parameters:
  ///   - [connectionChecker]: The InternetConnectionChecker instance to use
  ///     for checking connectivity. Should be null on web platforms.
  NetworkInfoImpl({this.connectionChecker});

  @override
  Future<bool> get isConnected async {
    // Always return true on web to avoid crash (InternetConnectionChecker uses raw sockets)
    if (kIsWeb) return Future.value(true);
    
    // Fallback: if no connection checker provided, assume connected
    if (connectionChecker == null) return Future.value(true);
    
    // Use the connection checker on mobile platforms
    return connectionChecker!.hasConnection;
  }
}

