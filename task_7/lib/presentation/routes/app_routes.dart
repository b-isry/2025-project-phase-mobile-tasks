import 'package:flutter/material.dart';
import '../pages/product_list_page.dart';
import '../pages/product_detail_page.dart';
import '../pages/product_form_page.dart';
import '../../domain/entities/product.dart';

/// Central route configuration for the app
/// 
/// All named routes are defined here following Clean Architecture principles.
/// Routes handle navigation arguments and provide proper bloc context.
class AppRoutes {
  // Route names
  static const String productList = '/';
  static const String productDetail = '/product';
  static const String productCreate = '/product/create';
  static const String productEdit = '/product/edit';

  /// Get all static routes
  static Map<String, WidgetBuilder> get routes => {
        productList: (context) => const ProductListPage(),
      };

  /// Generate routes dynamically with arguments
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case productDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        final productId = args?['productId'] as String?;
        if (productId == null) {
          return _errorRoute('Product ID is required');
        }
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ProductDetailPage(productId: productId),
        );

      case productCreate:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ProductFormPage(),
        );

      case productEdit:
        final args = settings.arguments as Map<String, dynamic>?;
        final product = args?['product'] as Product?;
        if (product == null) {
          return _errorRoute('Product is required for editing');
        }
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ProductFormPage(product: product),
        );

      default:
        return null;
    }
  }

  /// Error route for invalid navigation
  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text(message)),
      ),
    );
  }
}
