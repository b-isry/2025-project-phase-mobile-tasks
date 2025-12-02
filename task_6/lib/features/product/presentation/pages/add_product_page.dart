import 'package:flutter/material.dart';
import 'package:task_6/core/theme/app_theme.dart';

class AddProductPage extends StatelessWidget {
  const AddProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.inputFillColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.image_outlined, size: 48, color: Colors.grey),
                  const SizedBox(height: 12),
                  Text(
                    'upload image',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('name'),
            const SizedBox(height: 8),
            const TextField(
              decoration: InputDecoration(),
            ),
            const SizedBox(height: 16),
            const Text('category'),
            const SizedBox(height: 8),
            const TextField(
              decoration: InputDecoration(),
            ),
            const SizedBox(height: 16),
            const Text('price'),
            const SizedBox(height: 8),
            const TextField(
              decoration: InputDecoration(
                suffixIcon: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text('\$', style: TextStyle(fontSize: 16)),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            const Text('description'),
            const SizedBox(height: 8),
            const TextField(
              maxLines: 5,
              decoration: InputDecoration(),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppTheme.primaryColor,
                   shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('ADD', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
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
          ],
        ),
      ),
    );
  }
}

