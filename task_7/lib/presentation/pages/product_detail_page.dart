import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart' as error_widget;
import '../../domain/entities/product.dart';
import '../../core/injection/injection_container.dart' as di;

/// Page displaying detailed information about a single product
/// 
/// This page uses BlocProvider to provide ProductBloc and displays
/// product details. It handles GetSingleProductEvent and provides
/// UI controls for updating and deleting the product.
class ProductDetailPage extends StatelessWidget {
  /// The ID of the product to display
  final String productId;

  const ProductDetailPage({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    // Try to get bloc from parent, otherwise create new one
    ProductBloc bloc;
    try {
      bloc = context.read<ProductBloc>();
    } catch (_) {
      bloc = di.sl<ProductBloc>();
    }
    
    // Dispatch event to load product
    bloc.add(GetSingleProductEvent(productId));

    return BlocProvider.value(
      value: bloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Product Details'),
          actions: [
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is LoadedSingleProductState) {
                  return IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _navigateToEditProduct(context, state.product),
                    tooltip: 'Edit',
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: const _ProductDetailBody(),
      ),
    );
  }

  void _navigateToEditProduct(BuildContext context, Product product) {
    final bloc = context.read<ProductBloc>();
    Navigator.of(context)
        .pushNamed(
          '/product/edit',
          arguments: {'product': product},
        )
        .then((_) {
      // Refresh product after returning from form
      if (context.mounted) {
        bloc.add(GetSingleProductEvent(productId));
      }
    });
  }
}

/// Body widget that handles all state transitions
class _ProductDetailBody extends StatelessWidget {
  const _ProductDetailBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is LoadingState) {
          return const LoadingWidget(
            message: 'Loading product...',
          );
        }

        if (state is ErrorState) {
          return error_widget.ProductErrorWidget(
            message: state.message,
            onRetry: () {
              final productId = (context.read<ProductBloc>().state
                      as LoadedSingleProductState?)
                  ?.product
                  .id;
              if (productId != null) {
                context.read<ProductBloc>().add(GetSingleProductEvent(productId));
              }
            },
          );
        }

        if (state is LoadedSingleProductState) {
          return _buildProductDetails(context, state.product);
        }

        // Fallback
        return const Center(
          child: Text('Product not found'),
        );
      },
    );
  }

  Widget _buildProductDetails(BuildContext context, Product product) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image placeholder
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: product.imageUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildPlaceholderIcon(context),
                    ),
                  )
                : _buildPlaceholderIcon(context),
          ),
          const SizedBox(height: 24),
          // Product name
          Text(
            product.name,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          // Price
          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          // Description
          Text(
            'Description',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            product.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 32),
          // Delete button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showDeleteConfirmation(context, product),
              icon: const Icon(Icons.delete_outline),
              label: const Text('Delete Product'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderIcon(BuildContext context) {
    return Icon(
      Icons.shopping_bag_outlined,
      color: Theme.of(context).colorScheme.primary,
      size: 64,
    );
  }

  void _showDeleteConfirmation(BuildContext context, Product product) {
    final bloc = context.read<ProductBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) => BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is LoadedAllProductsState) {
            // Product deleted successfully
            Navigator.of(dialogContext).pop(); // Close dialog
            Navigator.of(context).pop(); // Go back to list
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Product deleted successfully!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          } else if (state is ErrorState) {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Theme.of(context).colorScheme.error,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        child: AlertDialog(
          title: const Text('Delete Product'),
          content: Text('Are you sure you want to delete "${product.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                bloc.add(DeleteProductEvent(product.id));
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}
