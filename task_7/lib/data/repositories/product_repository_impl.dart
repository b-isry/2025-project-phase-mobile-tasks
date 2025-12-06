import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/usecases/insert_product_usecase.dart';

/// Concrete implementation of ProductRepository
/// This handles the actual data operations (currently in-memory)
class ProductRepositoryImpl implements ProductRepository, ProductRepositoryInterface {
  final List<Product> _products;

  ProductRepositoryImpl({List<Product>? initialProducts})
      : _products = initialProducts ?? [
          Product(
            id: '1',
            name: 'Laptop',
            description: 'High-performance laptop for developers',
            imageUrl: '',
            price: 999.99,
          ),
          Product(
            id: '2',
            name: 'Smartphone',
            description: 'Latest flagship smartphone with amazing camera',
            imageUrl: '',
            price: 799.99,
          ),
          Product(
            id: '3',
            name: 'Headphones',
            description: 'Noise-cancelling wireless headphones',
            imageUrl: '',
            price: 299.99,
          ),
        ];

  @override
  Future<List<Product>> getAllProducts() async {
    // Simulate async operation
    return List.unmodifiable(_products);
  }

  @override
  Future<Product?> getProductById(String id) async {
    // Simulate async operation
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> createProduct(Product product) async {
    // Simulate async operation
    _products.add(product);
  }

  @override
  Future<void> insertProduct(Product product) async {
    // Delegate to createProduct for compatibility
    await createProduct(product);
  }

  @override
  Future<void> updateProduct(Product product) async {
    // Simulate async operation
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    // Simulate async operation
    _products.removeWhere((product) => product.id == id);
  }

  @override
  Future<Product?> getProduct(String id) async {
    // Delegate to getProductById for compatibility
    return await getProductById(id);
  }

  /// Generate a unique ID for new products (helper method)
  String generateId() {
    if (_products.isEmpty) return '1';
    final ids = _products.map((p) => int.tryParse(p.id) ?? 0).toList();
    final maxId = ids.reduce((a, b) => a > b ? a : b);
    return (maxId + 1).toString();
  }
}

