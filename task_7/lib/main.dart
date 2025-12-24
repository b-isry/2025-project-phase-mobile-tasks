import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/product_provider.dart';
import 'routes.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  
  runApp(MyApp(sharedPreferences: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  const MyApp({super.key, required this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductProvider(sharedPreferences: sharedPreferences),
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

