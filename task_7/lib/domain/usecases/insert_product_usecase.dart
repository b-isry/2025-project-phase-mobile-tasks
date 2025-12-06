import '../entities/product.dart';

/// Parameters for inserting a product
/// 
/// Wraps the product to be inserted following the use case parameter pattern.
class InsertProductParams {
  /// The product to be inserted
  final Product product;

  /// Creates parameters for inserting a product
  InsertProductParams(this.product);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InsertProductParams && other.product == product;
  }

  @override
  int get hashCode => product.hashCode;
}

/// Use case for inserting a new product
/// 
/// This use case handles the business logic for adding a new product to the system.
/// It follows the Single Responsibility Principle by focusing only on product insertion.
/// 
/// Example usage:
/// ```dart
/// final useCase = InsertProductUsecase(repository);
/// await useCase(InsertProductParams(newProduct));
/// ```
class InsertProductUsecase {
  /// Repository abstraction for data operations
  final ProductRepositoryInterface _repository;

  /// Creates an instance of InsertProductUsecase
  /// 
  /// Requires a [ProductRepositoryInterface] implementation for data persistence.
  InsertProductUsecase(this._repository);

  /// Executes the use case to insert a product
  /// 
  /// Takes [InsertProductParams] containing the product to insert.
  /// Returns a [Future] that completes when the product is successfully inserted.
  /// 
  /// Throws an exception if the insertion fails.
  Future<void> call(InsertProductParams params) async {
    return await _repository.insertProduct(params.product);
  }
}

/// Abstract interface for product repository operations
/// 
/// This interface defines the contract that must be implemented by the data layer.
/// It follows the Dependency Inversion Principle by depending on abstractions.
abstract class ProductRepositoryInterface {
  /// Inserts a new product
  Future<void> insertProduct(Product product);
  
  /// Updates an existing product
  Future<void> updateProduct(Product product);
  
  /// Deletes a product by ID
  Future<void> deleteProduct(String id);
  
  /// Retrieves a product by ID
  Future<Product?> getProduct(String id);
}

