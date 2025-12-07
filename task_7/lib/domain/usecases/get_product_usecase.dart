import '../entities/product.dart';
import '../repositories/product_repository_contract.dart';

/// Parameters for getting a product
/// 
/// Wraps the product ID to be retrieved following the use case parameter pattern.
class GetProductParams {
  /// The ID of the product to retrieve
  final String productId;

  /// Creates parameters for getting a product
  GetProductParams(this.productId);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GetProductParams && other.productId == productId;
  }

  @override
  int get hashCode => productId.hashCode;
}

/// Use case for retrieving a product by ID
/// 
/// This use case handles the business logic for fetching a specific product.
/// It follows the Single Responsibility Principle by focusing only on product retrieval.
/// 
/// Example usage:
/// ```dart
/// final useCase = GetProductUsecase(repository);
/// final product = await useCase(GetProductParams('product-id-123'));
/// ```
class GetProductUsecase {
  /// Repository contract for data operations
  final ProductRepositoryContract _repository;

  /// Creates an instance of GetProductUsecase
  /// 
  /// Requires a [ProductRepositoryContract] implementation for data access.
  GetProductUsecase(this._repository);

  /// Executes the use case to retrieve a product
  /// 
  /// Takes [GetProductParams] containing the ID of the product to retrieve.
  /// Returns a [Future] with the product if found, or null if not found.
  /// 
  /// Throws an exception if the retrieval operation fails.
  Future<Product?> call(GetProductParams params) async {
    return await _repository.getProductById(params.productId);
  }
}

