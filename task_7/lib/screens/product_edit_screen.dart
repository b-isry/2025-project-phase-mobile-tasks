import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import '../routes.dart';
import '../theme/app_theme.dart';
import '../widgets/pastel_button.dart';

/// ProductEditScreen handles both adding and editing products with pastel aesthetic
class ProductEditScreen extends StatefulWidget {
  const ProductEditScreen({super.key});

  @override
  State<ProductEditScreen> createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  bool _isEditMode = false;
  Product? _originalProduct;
  bool _hasChanges = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // ROUTING: Extract arguments to determine add or edit mode
    final args = ModalRoute.of(context)!.settings.arguments as ProductEditArguments;
    _isEditMode = args.isEditMode;

    // If editing, load the product data
    if (_isEditMode && _originalProduct == null) {
      final provider = Provider.of<ProductProvider>(context, listen: false);
      _originalProduct = provider.getProductById(args.productId!);
      
      if (_originalProduct != null) {
        _titleController.text = _originalProduct!.title;
        _descriptionController.text = _originalProduct!.description;
      }
    }

    // Track changes for unsaved changes dialog
    _titleController.addListener(_onFieldChanged);
    _descriptionController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    if (!_hasChanges) {
      setState(() {
        _hasChanges = true;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Handle back button press
      onWillPop: () async {
        if (_hasChanges) {
          return await _showDiscardDialog() ?? false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              _isEditMode ? 'Edit Product' : 'Add Product',
              key: ValueKey(_isEditMode),
            ),
          ),
          leading: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.lavender.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.close, size: 20),
            ),
            onPressed: _handleCancel,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Decorative header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: AppColors.getPastelGradient(AppColors.lavender),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 48,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isEditMode ? 'Update Product Details' : 'Create New Product',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                
                // Title field
                TextFormField(
                  key: const Key('title_field'),
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Product Title',
                    hintText: 'Enter product title',
                    prefixIcon: Icon(Icons.shopping_bag_outlined, color: AppColors.lavender),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Title is required';
                    }
                    if (value.trim().length < 3) {
                      return 'Title must be at least 3 characters';
                    }
                    return null;
                  },
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 20),
                
                // Description field
                TextFormField(
                  key: const Key('description_field'),
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter product description',
                    prefixIcon: Icon(Icons.description_outlined, color: AppColors.mint),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Description is required';
                    }
                    if (value.trim().length < 10) {
                      return 'Description must be at least 10 characters';
                    }
                    return null;
                  },
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 32),
                
                // Save button
                PastelButton(
                  key: const Key('save_product_button'),
                  text: _isEditMode ? 'Save Changes' : 'Add Product',
                  icon: Icons.check_circle_outline,
                  color: AppColors.lavender,
                  onPressed: _handleSave,
                ),
                const SizedBox(height: 12),
                
                // Cancel button
                TextButton(
                  onPressed: _handleCancel,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    foregroundColor: AppColors.textLight,
                  ),
                  child: const Text('Cancel', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Handle save button press
  void _handleSave() {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    Product resultProduct;

    if (_isEditMode && _originalProduct != null) {
      // Update existing product
      resultProduct = _originalProduct!.copyWith(
        title: title,
        description: description,
      );
    } else {
      // Create new product
      final provider = Provider.of<ProductProvider>(context, listen: false);
      final newId = provider.generateId();
      resultProduct = Product(
        id: newId,
        title: title,
        description: description,
      );
    }

    // ROUTING: Return the product to the previous screen
    Navigator.pop(context, resultProduct);
  }

  /// Handle cancel button press
  void _handleCancel() async {
    if (_hasChanges) {
      final shouldDiscard = await _showDiscardDialog();
      if (shouldDiscard == true) {
        // ROUTING: Pop without returning data (null)
        if (mounted) {
          Navigator.pop(context);
        }
      }
    } else {
      // ROUTING: Pop without returning data (null)
      Navigator.pop(context);
    }
  }

  /// Show dialog to confirm discarding changes
  Future<bool?> _showDiscardDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.peach.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.warning_amber_rounded, color: AppColors.peach),
            ),
            const SizedBox(width: 12),
            const Text('Discard Changes?'),
          ],
        ),
        content: Text(
          'You have unsaved changes. Are you sure you want to discard them?',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.lavender,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text('Continue Editing', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.softRed,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text(
              'Discard',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

