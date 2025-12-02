import 'package:flutter/material.dart';
import 'package:task_6/core/theme/app_theme.dart';
import 'package:task_6/features/product/models/product.dart';

class DetailsPage extends StatefulWidget {
  final Product product;

  const DetailsPage({super.key, required this.product});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  int _selectedSize = 41;
  final List<int> _sizes = [39, 40, 41, 42, 43, 44];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Header
                Stack(
                  children: [
                    SizedBox(
                      height: 280,
                      width: double.infinity,
                      child: Image.network(
                        widget.product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(color: Colors.grey[200]);
                        },
                      ),
                    ),
                     Positioned(
                      top: 40,
                      left: 20,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.black),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category and Rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.product.category,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 20),
                              const SizedBox(width: 4),
                              Text(
                                '(${widget.product.rating})',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Name and Price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.product.name,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          Text(
                            '\$${widget.product.price}',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Size Selector
                      Text(
                        'Size:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _sizes.map((size) {
                            final isSelected = size == _selectedSize;
                            return Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedSize = size;
                                  });
                                },
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: isSelected ? AppTheme.primaryColor : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      if (!isSelected)
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.1),
                                          spreadRadius: 1,
                                          blurRadius: 5,
                                        ),
                                    ],
                                    border: isSelected ? null : Border.all(color: Colors.grey[200]!),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    size.toString(),
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : Colors.black,
                                      fontSize: 20,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Description
                      Text(
                        widget.product.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
                      ),
                      const SizedBox(height: 100), // Spacing for bottom buttons
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Bottom Buttons
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: AppTheme.errorColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('DELETE', style: TextStyle(color: AppTheme.errorColor)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppTheme.primaryColor,
                         shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('UPDATE', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

