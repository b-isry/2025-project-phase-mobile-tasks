import '../entities/product.dart';

/// Repository contract for product data operations
/// 
/// This abstract interface defines the contract that must be implemented
/// by the data layer repository. It follows the Dependency Inversion Principle
/// by keeping the domain layer independent of implementation details.
/// 
/// The repository acts as a mediator between the domain layer (use cases)
/// and the data layer (data sources), abstracting away the details of
/// data retrieval and persistence.
/// 
/// Example usage:
/// ```dart
/// class ProductRepositoryImpl implements ProductRepositoryContract {
///   @override
///   Future<List<Product>> getAllProducts() async {
///     // Implementation details...
///   }
/// }
/// ```
abstract class ProductRepositoryContract {
  /// Retrieves all products from the data source
  /// 
  /// This method fetches all available products, potentially from multiple
  /// data sources (remote API, local cache, etc.). The implementation should
  /// handle data source selection and error handling.
  /// 
  /// Returns a [Future] that resolves to a list of [Product] objects.
  /// The list will be empty if no products are available.
  /// 
  /// Throws an exception if the operation fails (e.g., network error,
  /// database error).
  Future<List<Product>> getAllProducts();

  /// Retrieves a specific product by its unique identifier
  /// 
  /// This method fetches a single product using its ID. It should first
  /// check local cache for better performance, then fall back to remote
  /// data source if needed.
  /// 
  /// Parameters:
  ///   - [id]: The unique identifier of the product to retrieve
  /// 
  /// Returns a [Future] that resolves to:
  ///   - The [Product] object if found
  ///   - null if no product with the given ID exists
  /// 
  /// Throws an exception if the operation fails.
  Future<Product?> getProductById(String id);

  /// Creates a new product in the data source
  /// 
  /// This method persists a new product to the data source. The implementation
  /// should handle both remote persistence (API call) and local caching for
  /// offline support.
  /// 
  /// Parameters:
  ///   - [product]: The product object to create. Must have a valid ID.
  /// 
  /// Returns a [Future] that completes when the product is successfully created.
  /// 
  /// Throws an exception if:
  ///   - The product ID is invalid or already exists
  ///   - Network/storage operation fails
  ///   - Validation fails
  Future<void> createProduct(Product product);

  /// Updates an existing product in the data source
  /// 
  /// This method modifies an existing product's data. The implementation
  /// should update both remote and local data sources to maintain consistency.
  /// 
  /// Parameters:
  ///   - [product]: The product object with updated data. The ID must match
  ///     an existing product.
  /// 
  /// Returns a [Future] that completes when the product is successfully updated.
  /// 
  /// Throws an exception if:
  ///   - The product ID doesn't exist
  ///   - Network/storage operation fails
  ///   - Validation fails
  Future<void> updateProduct(Product product);

  /// Deletes a product from the data source
  /// 
  /// This method removes a product permanently from both remote and local
  /// data sources. This operation should be handled carefully as it's
  /// typically irreversible.
  /// 
  /// Parameters:
  ///   - [id]: The unique identifier of the product to delete
  /// 
  /// Returns a [Future] that completes when the product is successfully deleted.
  /// 
  /// Throws an exception if:
  ///   - The product ID doesn't exist
  ///   - Network/storage operation fails
  ///   - The operation is not permitted
  Future<void> deleteProduct(String id);
}

