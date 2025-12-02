import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:product_manager/models/product.dart';
import 'package:product_manager/providers/product_provider.dart';
import 'package:product_manager/routes.dart';
import 'package:product_manager/theme/app_theme.dart';

/// Test-only ProductProvider that can start with custom products
class TestProductProvider extends ProductProvider {
  TestProductProvider({List<Product>? initialProducts}) {
    // Clear the default products from parent
    _clearDefaultProducts();
    // Add test products if provided
    if (initialProducts != null) {
      for (final product in initialProducts) {
        addProduct(product);
      }
    }
  }

  void _clearDefaultProducts() {
    // Remove all default products that were added in the parent constructor
    // Get IDs first to avoid concurrent modification
    final ids = products.map((p) => p.id).toList();
    for (final id in ids) {
      deleteProduct(id);
    }
  }
}

/// Creates a MaterialApp wrapper with provider for testing
Widget createTestApp({
  required Widget child,
  List<Product>? initialProducts,
}) {
  // Disable shadows for testing
  debugDisableShadows = true;

  final provider = TestProductProvider(initialProducts: initialProducts);

  return ChangeNotifierProvider<ProductProvider>.value(
    value: provider,
    child: MaterialApp(
      theme: AppTheme.theme,
      home: child,
      onGenerateRoute: Routes.onGenerateRoute,
    ),
  );
}
