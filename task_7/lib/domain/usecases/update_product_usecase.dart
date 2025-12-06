import '../entities/product.dart';
import 'insert_product_usecase.dart';

/// Parameters for updating a product
/// 
/// Wraps the product to be updated following the use case parameter pattern.
class UpdateProductParams {
  /// The product with updated data
  final Product product;

  /// Creates parameters for updating a product
  UpdateProductParams(this.product);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UpdateProductParams && other.product == product;
  }

  @override
  int get hashCode => product.hashCode;
}

/// Use case for updating an existing product
/// 
/// This use case handles the business logic for modifying an existing product.
/// It follows the Single Responsibility Principle by focusing only on product updates.
/// 
/// Example usage:
/// ```dart
/// final useCase = UpdateProductUsecase(repository);
/// await useCase(UpdateProductParams(updatedProduct));
/// ```
class UpdateProductUsecase {
  /// Repository abstraction for data operations
  final ProductRepositoryInterface _repository;

  /// Creates an instance of UpdateProductUsecase
  /// 
  /// Requires a [ProductRepositoryInterface] implementation for data persistence.
  UpdateProductUsecase(this._repository);

  /// Executes the use case to update a product
  /// 
  /// Takes [UpdateProductParams] containing the product with updated data.
  /// Returns a [Future] that completes when the product is successfully updated.
  /// 
  /// Throws an exception if the update fails or the product doesn't exist.
  Future<void> call(UpdateProductParams params) async {
    return await _repository.updateProduct(params.product);
  }
}
