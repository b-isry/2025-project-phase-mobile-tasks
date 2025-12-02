import 'package:flutter/material.dart';
import 'package:task_6/core/theme/app_theme.dart';
import 'package:task_6/features/product/models/product.dart';
import 'package:task_6/features/product/presentation/pages/add_product_page.dart';
import 'package:task_6/features/product/presentation/pages/details_page.dart';
import 'package:task_6/features/product/presentation/pages/home_page.dart';
import 'package:task_6/features/product/presentation/pages/search_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/search': (context) => const SearchPage(),
        '/add-product': (context) => const AddProductPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/details') {
          final product = settings.arguments as Product;
          return MaterialPageRoute(
            builder: (context) => DetailsPage(product: product),
          );
        }
        return null;
      },
    );
  }
}
