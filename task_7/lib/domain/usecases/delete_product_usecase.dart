import '../repositories/product_repository_contract.dart';

/// Parameters for deleting a product
/// 
/// Wraps the product ID to be deleted following the use case parameter pattern.
class DeleteProductParams {
  /// The ID of the product to delete
  final String productId;

  /// Creates parameters for deleting a product
  DeleteProductParams(this.productId);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DeleteProductParams && other.productId == productId;
  }

  @override
  int get hashCode => productId.hashCode;
}

/// Use case for deleting a product
/// 
/// This use case handles the business logic for removing a product from the system.
/// It follows the Single Responsibility Principle by focusing only on product deletion.
/// 
/// Example usage:
/// ```dart
/// final useCase = DeleteProductUsecase(repository);
/// await useCase(DeleteProductParams('product-id-123'));
/// ```
class DeleteProductUsecase {
  /// Repository contract for data operations
  final ProductRepositoryContract _repository;

  /// Creates an instance of DeleteProductUsecase
  /// 
  /// Requires a [ProductRepositoryContract] implementation for data persistence.
  DeleteProductUsecase(this._repository);

  /// Executes the use case to delete a product
  /// 
  /// Takes [DeleteProductParams] containing the ID of the product to delete.
  /// Returns a [Future] that completes when the product is successfully deleted.
  /// 
  /// Throws an exception if the deletion fails or the product doesn't exist.
  Future<void> call(DeleteProductParams params) async {
    return await _repository.deleteProduct(params.productId);
  }
}
