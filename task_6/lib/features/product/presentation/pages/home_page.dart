import 'package:flutter/material.dart';
import 'package:task_6/core/theme/app_theme.dart';
import 'package:task_6/features/product/models/product.dart';
import 'package:task_6/features/product/presentation/widgets/product_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-product');
        },
        backgroundColor: AppTheme.primaryColor,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'July 14, 2023',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[500],
                            ),
                      ),
                      const SizedBox(height: 4),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Hello, ',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w400,
                                  ),
                            ),
                            TextSpan(
                              text: 'Yohannes',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.notifications_none, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Title and Search Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Available Products',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/search');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(Icons.search, color: Colors.grey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Product List
              Expanded(
                child: ListView.separated(
                  itemCount: Product.dummyProducts.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 24),
                  itemBuilder: (context, index) {
                    return ProductCard(
                      product: Product.dummyProducts[index],
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/details',
                          arguments: Product.dummyProducts[index],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

