import '../../../domain/entities/product.dart';
import 'product_remote_datasource.dart';

/// Simple in-memory implementation of ProductRemoteDataSource
/// 
/// This is a basic implementation for development/testing purposes.
/// In production, this would make actual HTTP requests to a backend API.
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Map<String, Product> _products = {};

  @override
  Future<List<Product>> fetchAllProducts() async {
    return _products.values.toList();
  }

  @override
  Future<Product?> fetchProductById(String id) async {
    return _products[id];
  }

  @override
  Future<void> addProduct(Product product) async {
    _products[product.id] = product;
  }

  @override
  Future<void> editProduct(Product product) async {
    if (!_products.containsKey(product.id)) {
      throw Exception('Product not found');
    }
    _products[product.id] = product;
  }

  @override
  Future<void> removeProduct(String id) async {
    if (!_products.containsKey(id)) {
      throw Exception('Product not found');
    }
    _products.remove(id);
  }

  /// Generates a unique ID for new products
  /// Returns a UUID v4-like string
  String generateId() {
    // Simple UUID v4-like generator
    final random = DateTime.now().millisecondsSinceEpoch.toString();
    final random2 = (DateTime.now().microsecondsSinceEpoch % 1000000).toString();
    return '${random}-${random2}-${DateTime.now().hashCode.abs()}';
  }
}

