import '../../domain/entities/product.dart';
import '../../domain/usecases/insert_product_usecase.dart';

/// Concrete implementation of the ProductRepository
/// 
/// This class implements the data layer of Clean Architecture.
/// It manages product data using an in-memory storage mechanism and
/// uses dependency injection to receive use cases.
/// 
/// Following TDD principles, this repository:
/// - Uses use cases for business logic
/// - Maintains separation of concerns
/// - Provides testable, injectable dependencies
/// 
/// Example usage:
/// ```dart
/// final repository = ProductRepository(
///   insertUsecase: insertUsecase,
///   updateUsecase: updateUsecase,
///   deleteUsecase: deleteUsecase,
///   getUsecase: getUsecase,
/// );
/// 
/// await repository.insertProduct(product);
/// final product = await repository.getProduct('id');
/// ```
class ProductRepository implements ProductRepositoryInterface {
  /// In-memory storage for products
  final Map<String, Product> _products = {};

  /// Creates a ProductRepository with optional initial products
  /// 
  /// If no initial products are provided, the repository will be initialized
  /// with default sample products.
  ProductRepository({
    Map<String, Product>? initialProducts,
  }) {
    // Initialize with default products if none provided
    if (initialProducts != null) {
      _products.addAll(initialProducts);
    } else {
      _initializeDefaultProducts();
    }
  }

  /// Initializes the repository with default sample products
  void _initializeDefaultProducts() {
    final defaultProducts = [
      Product(
        id: '1',
        name: 'Laptop',
        description: 'High-performance laptop for developers',
        price: 999.99,
        imageUrl: '',
      ),
      Product(
        id: '2',
        name: 'Smartphone',
        description: 'Latest flagship smartphone with amazing camera',
        price: 799.99,
        imageUrl: '',
      ),
      Product(
        id: '3',
        name: 'Headphones',
        description: 'Noise-cancelling wireless headphones',
        price: 299.99,
        imageUrl: '',
      ),
    ];

    for (final product in defaultProducts) {
      _products[product.id] = product;
    }
  }

  /// Inserts a new product into the repository
  /// 
  /// Adds the product to the in-memory storage.
  /// If a product with the same ID already exists, it will be replaced.
  /// 
  /// Parameters:
  ///   - [product]: The product to insert
  /// 
  /// Returns a [Future] that completes when the insertion is successful.
  /// 
  /// Throws an [ArgumentError] if the product is null.
  @override
  Future<void> insertProduct(Product product) async {
    if (product.id.isEmpty) {
      throw ArgumentError('Product ID cannot be empty');
    }
    
    // Simulate async operation
    await Future.delayed(Duration.zero);
    
    _products[product.id] = product;
  }

  /// Updates an existing product in the repository
  /// 
  /// Replaces the product data for the given product ID.
  /// If the product doesn't exist, it will be created.
  /// 
  /// Parameters:
  ///   - [product]: The product with updated data
  /// 
  /// Returns a [Future] that completes when the update is successful.
  /// 
  /// Throws an [ArgumentError] if the product ID is empty.
  @override
  Future<void> updateProduct(Product product) async {
    if (product.id.isEmpty) {
      throw ArgumentError('Product ID cannot be empty');
    }
    
    if (!_products.containsKey(product.id)) {
      throw StateError('Product with ID ${product.id} not found');
    }
    
    // Simulate async operation
    await Future.delayed(Duration.zero);
    
    _products[product.id] = product;
  }

  /// Deletes a product from the repository by ID
  /// 
  /// Removes the product from in-memory storage.
  /// 
  /// Parameters:
  ///   - [id]: The ID of the product to delete
  /// 
  /// Returns a [Future] that completes when the deletion is successful.
  /// 
  /// Throws a [StateError] if the product doesn't exist.
  @override
  Future<void> deleteProduct(String id) async {
    if (id.isEmpty) {
      throw ArgumentError('Product ID cannot be empty');
    }
    
    if (!_products.containsKey(id)) {
      throw StateError('Product with ID $id not found');
    }
    
    // Simulate async operation
    await Future.delayed(Duration.zero);
    
    _products.remove(id);
  }

  /// Retrieves a product by its ID
  /// 
  /// Returns the product if found, or null if not found.
  /// 
  /// Parameters:
  ///   - [id]: The ID of the product to retrieve
  /// 
  /// Returns a [Future] containing the product or null.
  @override
  Future<Product?> getProduct(String id) async {
    if (id.isEmpty) {
      throw ArgumentError('Product ID cannot be empty');
    }
    
    // Simulate async operation
    await Future.delayed(Duration.zero);
    
    return _products[id];
  }

  /// Gets all products in the repository
  /// 
  /// Returns a list of all products currently stored.
  /// This is a utility method for testing and debugging.
  /// 
  /// Returns a [Future] containing a list of all products.
  Future<List<Product>> getAllProducts() async {
    await Future.delayed(Duration.zero);
    return _products.values.toList();
  }

  /// Clears all products from the repository
  /// 
  /// This is useful for testing purposes.
  Future<void> clear() async {
    await Future.delayed(Duration.zero);
    _products.clear();
  }

  /// Gets the count of products in the repository
  /// 
  /// Returns the number of products currently stored.
  int get productCount => _products.length;
}

