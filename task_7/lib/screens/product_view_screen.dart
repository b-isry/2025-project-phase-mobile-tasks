import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import '../routes.dart';
import '../theme/app_theme.dart';
import '../widgets/pastel_placeholder_image.dart';
import '../widgets/pastel_button.dart';

/// ProductViewScreen displays a single product's full details with pastel aesthetic
class ProductViewScreen extends StatelessWidget {
  const ProductViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ROUTING: Extract arguments from route settings
    final args = ModalRoute.of(context)!.settings.arguments as ProductViewArguments;
    final provider = Provider.of<ProductProvider>(context, listen: false);
    final product = provider.getProductById(args.productId);

    // Handle case where product is not found
    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Product Not Found')),
        body: const Center(
          child: Text('Product not found'),
        ),
      );
    }

    final productIndex = provider.products.indexOf(product);
    final pastelColor = AppColors.getRandomPastel(productIndex);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.lavender.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.edit, size: 20),
            ),
            onPressed: () => _navigateToEdit(context, product),
            tooltip: 'Edit',
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.softRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.delete, size: 20, color: AppColors.softRed),
            ),
            onPressed: () => _deleteProduct(context, provider, product),
            tooltip: 'Delete',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Large hero card with image
            Padding(
              padding: const EdgeInsets.all(24),
              child: PastelPlaceholderImage(
                color: pastelColor,
                height: 300,
                borderRadius: 30,
                heroTag: 'product-image-${product.id}',
              ),
            ),
            
            // Product title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                product.title,
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            
            // Description card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.lavender.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: pastelColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.description_outlined,
                            color: pastelColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Description',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      product.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Product ID card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.lavender.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.mint.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.tag,
                        color: AppColors.mint,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Product ID',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          product.id,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            // Action buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: PastelButton(
                text: 'Edit Product',
                icon: Icons.edit,
                color: AppColors.lavender,
                onPressed: () => _navigateToEdit(context, product),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  /// ROUTING: Navigate to edit screen
  Future<void> _navigateToEdit(BuildContext context, Product product) async {
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

  /// Delete product with confirmation
  void _deleteProduct(BuildContext context, ProductProvider provider, Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Delete Product',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Text(
          'Are you sure you want to delete "${product.title}"?',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.textLight),
            ),
          ),
          TextButton(
            onPressed: () {
              provider.deleteProduct(product.id);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Return to home screen
              _showSnackBar(context, 'Product deleted successfully');
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.softRed, fontWeight: FontWeight.w600),
            ),
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

