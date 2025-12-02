import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import '../routes.dart';
import '../theme/app_theme.dart';
import '../widgets/product_card.dart';

/// HomeScreen displays a grid of all products with pastel aesthetic
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.lavender,
                  AppColors.mint,
                  AppColors.peach,
                ],
              ),
            ),
          ),
        ),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          final products = provider.products;

          if (products.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 80,
                    color: AppColors.lavender.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No products yet',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + to add your first product!',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                product: product,
                index: index,
                onTap: () => _navigateToProductView(context, product),
                onEdit: () => _navigateToEditProduct(context, product),
                onDelete: () => _deleteProduct(context, provider, product),
              );
            },
          );
        },
      ),
      floatingActionButton: Container(
        key: const Key('add_product_fab'),
        decoration: BoxDecoration(
          gradient: AppColors.getPastelGradient(AppColors.lavender),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.lavender.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () => _navigateToAddProduct(context),
          tooltip: 'Add Product',
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: AppColors.lavender),
          ),
        ),
      ),
    );
  }

  /// ROUTING: Navigate to product view screen
  void _navigateToProductView(BuildContext context, Product product) {
    Navigator.pushNamed(
      context,
      Routes.productView,
      arguments: ProductViewArguments(productId: product.id),
    );
  }

  /// ROUTING: Navigate to add product screen
  Future<void> _navigateToAddProduct(BuildContext context) async {
    // ROUTING: Pass null productId for add mode
    final result = await Navigator.pushNamed(
      context,
      Routes.productEdit,
      arguments: ProductEditArguments(),
    );

    // Handle returned product from edit screen
    if (result is Product && context.mounted) {
      final provider = Provider.of<ProductProvider>(context, listen: false);
      provider.addProduct(result);
      _showSnackBar(context, 'Product added successfully');
    }
  }

  /// ROUTING: Navigate to edit product screen
  Future<void> _navigateToEditProduct(BuildContext context, Product product) async {
    // ROUTING: Pass productId for edit mode
    final result = await Navigator.pushNamed(
      context,
      Routes.productEdit,
      arguments: ProductEditArguments(productId: product.id),
    );

    // Handle returned product from edit screen
    if (result is Product && context.mounted) {
      final provider = Provider.of<ProductProvider>(context, listen: false);
      provider.updateProduct(result);
      _showSnackBar(context, 'Product updated successfully');
    }
  }

  /// Delete a product with confirmation
  void _deleteProduct(BuildContext context, ProductProvider provider, Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.softRed.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.delete_outline, color: AppColors.softRed),
            ),
            const SizedBox(width: 12),
            const Text('Delete Product'),
          ],
        ),
        content: Text(
          'Are you sure you want to delete "${product.title}"?',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textLight,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.deleteProduct(product.id);
              Navigator.pop(context);
              _showSnackBar(context, 'Product deleted successfully');
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.softRed,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text('Delete', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.lavender,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

