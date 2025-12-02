import 'package:flutter/foundation.dart';
import '../models/product.dart';

/// Provider for managing products with CRUD operations
class ProductProvider extends ChangeNotifier {
  final List<Product> _products = [
    Product(
      id: '1',
      title: 'Laptop',
      description: 'High-performance laptop for developers',
    ),
    Product(
      id: '2',
      title: 'Smartphone',
      description: 'Latest flagship smartphone with amazing camera',
    ),
    Product(
      id: '3',
      title: 'Headphones',
      description: 'Noise-cancelling wireless headphones',
    ),
  ];

  List<Product> get products => List.unmodifiable(_products);

  /// Get a product by ID
  Product? getProductById(String id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Add a new product
  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  /// Update an existing product
  void updateProduct(Product updatedProduct) {
    final index = _products.indexWhere((p) => p.id == updatedProduct.id);
    if (index != -1) {
      _products[index] = updatedProduct;
      notifyListeners();
    }
  }

  /// Delete a product by ID
  void deleteProduct(String id) {
    _products.removeWhere((product) => product.id == id);
    notifyListeners();
  }

  /// Generate a unique ID for new products
  String generateId() {
    if (_products.isEmpty) return '1';
    final ids = _products.map((p) => int.tryParse(p.id) ?? 0).toList();
    final maxId = ids.reduce((a, b) => a > b ? a : b);
    return (maxId + 1).toString();
  }
}

