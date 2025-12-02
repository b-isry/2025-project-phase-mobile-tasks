import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/product_provider.dart';
import 'routes.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductProvider(),
      child: MaterialApp(
        title: 'Product Manager',
        theme: AppTheme.theme,
        // ROUTING: Define initial route and named routes
        initialRoute: Routes.home,
        routes: Routes.routes,
        onGenerateRoute: Routes.onGenerateRoute,
      ),
    );
  }
}

