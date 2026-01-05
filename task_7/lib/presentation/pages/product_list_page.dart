import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart' as error_widget;
import '../widgets/empty_state_widget.dart';
import '../widgets/product_list_item_widget.dart';

/// Main page displaying a list of all products
/// 
/// This page expects ProductBloc to be provided at a higher level (app root).
/// It handles all product state transitions and provides UI controls for CRUD operations.
class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ProductBloc>().add(const LoadAllProductsEvent());
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: const _ProductListBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreateProduct(context),
        child: const Icon(Icons.add),
        tooltip: 'Add Product',
      ),
    );
  }

  void _navigateToCreateProduct(BuildContext context) {
    final bloc = context.read<ProductBloc>();
    Navigator.of(context)
        .pushNamed('/product/create')
        .then((_) {
      // Refresh list after returning from form
      // Use the bloc reference captured before navigation to avoid context issues
      if (context.mounted) {
        bloc.add(const LoadAllProductsEvent());
      }
    });
  }
}

/// Body widget that handles all state transitions
class _ProductListBody extends StatelessWidget {
  const _ProductListBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is InitialState) {
          return const EmptyStateWidget(
            message: 'Welcome! Tap + to add your first product.',
          );
        }

        if (state is LoadingState) {
          return const LoadingWidget(
            message: 'Loading products...',
          );
        }

        if (state is ErrorState) {
          return error_widget.ProductErrorWidget(
            message: state.message,
            onRetry: () {
              context.read<ProductBloc>().add(const LoadAllProductsEvent());
            },
          );
        }

        if (state is LoadedAllProductsState) {
          if (state.products.isEmpty) {
            return const EmptyStateWidget();
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<ProductBloc>().add(const LoadAllProductsEvent());
              // Wait a bit for the state to update
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                return ProductListItemWidget(
                  product: product,
                  onTap: () => _navigateToProductDetail(context, product.id),
                  onDelete: () => _showDeleteConfirmation(context, product),
                );
              },
            ),
          );
        }

        // Fallback for any other state
        return const EmptyStateWidget();
      },
    );
  }

  void _navigateToProductDetail(BuildContext context, String productId) {
    final bloc = context.read<ProductBloc>();
    Navigator.of(context)
        .pushNamed(
          '/product',
          arguments: {'productId': productId},
        )
        .then((_) {
      // Refresh list after returning from detail
      // Use the bloc reference captured before navigation to avoid context issues
      if (context.mounted) {
        bloc.add(const LoadAllProductsEvent());
      }
    });
  }

  void _showDeleteConfirmation(BuildContext context, product) {
    final bloc = context.read<ProductBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) => BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is LoadedAllProductsState) {
            // Product deleted successfully
            Navigator.of(dialogContext).pop(); // Close dialog
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
