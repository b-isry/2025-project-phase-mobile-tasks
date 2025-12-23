/// Abstract interface for checking network connectivity
/// 
/// This interface provides a contract for checking whether the device
/// has an active internet connection. It follows the Dependency Inversion
/// Principle by allowing the repository to depend on an abstraction
/// rather than a concrete implementation.
/// 
/// Example usage:
/// ```dart
/// class NetworkInfoImpl implements NetworkInfo {
///   final InternetConnectionChecker connectionChecker;
///   
///   NetworkInfoImpl(this.connectionChecker);
///   
///   @override
///   Future<bool> get isConnected => connectionChecker.hasConnection;
/// }
/// ```
abstract class NetworkInfo {
  /// Checks if the device is currently connected to the internet
  /// 
  /// Returns a [Future] that resolves to:
  ///   - true if the device has an active internet connection
  ///   - false if the device is offline
  /// 
  /// This method should check actual connectivity, not just network interface status.
  Future<bool> get isConnected;
}
