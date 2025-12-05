import '../entities/product.dart';

/// Abstract repository interface for Product operations
/// This defines the contract that must be implemented by data layer
abstract class ProductRepository {
  /// Retrieve all products
  Future<List<Product>> getAllProducts();

  /// Retrieve a specific product by ID
  Future<Product?> getProductById(String id);

  /// Create a new product
  Future<void> createProduct(Product product);

  /// Update an existing product
  Future<void> updateProduct(Product product);

  /// Delete a product by ID
  Future<void> deleteProduct(String id);
}

