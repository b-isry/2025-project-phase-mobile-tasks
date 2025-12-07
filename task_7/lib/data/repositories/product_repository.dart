import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository_contract.dart';

/// Simple in-memory implementation of ProductRepository for testing
/// 
/// This class provides a basic implementation of the repository contract
/// using in-memory storage. It's useful for:
/// - Unit testing without complex dependencies
/// - Quick prototyping
/// - Testing use cases in isolation
/// 
/// For production use, consider using ProductRepositoryImpl with proper
/// data sources (remote API and local cache).
/// 
/// Example usage:
/// ```dart
/// final repository = ProductRepository(
///   initialProducts: {'1': product1, '2': product2},
/// );
/// 
/// await repository.insertProduct(product);
/// final product = await repository.getProduct('id');
/// ```
class ProductRepository implements ProductRepositoryContract {
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
  Future<void> createProduct(Product product) async {
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
  Future<Product?> getProductById(String id) async {
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
  @override
  Future<List<Product>> getAllProducts() async {
    await Future.delayed(Duration.zero);
    return _products.values.toList();
  }
  
  // Backward compatibility methods (non-override)
  Future<void> insertProduct(Product product) async {
    await createProduct(product);
  }
  
  Future<Product?> getProduct(String id) async {
    return await getProductById(id);
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

