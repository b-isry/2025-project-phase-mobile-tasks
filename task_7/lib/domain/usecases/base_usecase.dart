/// Base UseCase class following the callable class pattern
/// Type: The return type of the use case
/// Params: The parameters required by the use case
abstract class UseCase<Type, Params> {
  /// Execute the use case
  Future<Type> call(Params params);
}

/// Used when a use case doesn't require any parameters
class NoParams {}

