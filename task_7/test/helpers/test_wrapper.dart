import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:product_manager/models/product.dart';
import 'package:product_manager/providers/product_provider.dart';
import 'package:product_manager/routes.dart';
import 'package:product_manager/theme/app_theme.dart';
import 'package:product_manager/data/repositories/product_repository_impl.dart';

/// Creates a MaterialApp wrapper with provider for testing
Widget createTestApp({
  required Widget child,
  List<Product>? initialProducts,
}) {
  // Disable shadows for testing
  debugDisableShadows = true;

  // Create repository with test products
  final repository = ProductRepositoryImpl(
    initialProducts: initialProducts ?? [],
  );

  // Create provider with test repository
  final provider = ProductProvider(repository: repository);

  return ChangeNotifierProvider<ProductProvider>.value(
    value: provider,
    child: MaterialApp(
      theme: AppTheme.theme,
      home: child,
      onGenerateRoute: Routes.onGenerateRoute,
    ),
  );
}
