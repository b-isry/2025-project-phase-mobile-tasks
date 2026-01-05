import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';
import '../widgets/loading_widget.dart';
import '../../domain/entities/product.dart';
import '../../core/injection/injection_container.dart' as di;
import 'dart:math';

/// Page for creating or editing a product
/// 
/// This page uses BlocProvider to provide ProductBloc and handles
/// CreateProductEvent and UpdateProductEvent. It provides a form
/// for entering product information.
class ProductFormPage extends StatefulWidget {
  /// Optional product to edit. If null, creates a new product.
  final Product? product;

  const ProductFormPage({
    super.key,
    this.product,
  });

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.product?.description ?? '');
    _priceController = TextEditingController(
        text: widget.product?.price.toStringAsFixed(2) ?? '0.00');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.product != null;

    return BlocProvider(
      create: (_) => di.sl<ProductBloc>(),
      child: BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ErrorState && _isSubmitting) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
            setState(() => _isSubmitting = false);
          } else if ((state is LoadedAllProductsState ||
                  state is LoadedSingleProductState) &&
              _isSubmitting) {
            // Success - navigate back
            Navigator.of(context).pop();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(isEditMode ? 'Edit Product' : 'Add Product'),
          ),
          body: _buildForm(context, isEditMode),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, bool isEditMode) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        final isEditMode = widget.product != null;
        if (state is LoadingState && _isSubmitting) {
          return LoadingWidget(
            message: isEditMode ? 'Updating product...' : 'Creating product...',
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Name field
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Product Name',
                    hintText: 'Enter product name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.shopping_bag),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a product name';
                    }
                    if (value.trim().length < 3) {
                      return 'Name must be at least 3 characters';
                    }
                    return null;
                  },
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 16),
                // Description field
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter product description',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description),
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 16),
                // Price field
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    hintText: '0.00',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a price';
                    }
                    final price = double.tryParse(value);
                    if (price == null || price < 0) {
                      return 'Please enter a valid price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                // Submit button
                ElevatedButton(
                  onPressed: _isSubmitting ? null : () => _submitForm(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    isEditMode ? 'Update Product' : 'Create Product',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submitForm(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);

    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final price = double.parse(_priceController.text.trim());

    final product = widget.product?.copyWith(
          name: name,
          description: description,
          price: price,
        ) ??
        Product(
          id: _generateId(),
          name: name,
          description: description,
          price: price,
        );

    if (widget.product != null) {
      context.read<ProductBloc>().add(UpdateProductEvent(product));
    } else {
      context.read<ProductBloc>().add(CreateProductEvent(product));
    }
  }

  String _generateId() {
    // Simple ID generator - in production, this would come from the server
    return 'product_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1000)}';
  }
}
