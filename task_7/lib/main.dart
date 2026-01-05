import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/injection/injection_container.dart' as di;
import 'presentation/bloc/product_bloc.dart';
import 'presentation/bloc/product_event.dart';
import 'presentation/pages/product_list_page.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependency injection
  await di.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Provide ProductBloc at app root level for ProductListPage
      create: (_) => di.sl<ProductBloc>()..add(const LoadAllProductsEvent()),
      child: MaterialApp(
        title: 'Product Manager',
        theme: AppTheme.theme,
        debugShowCheckedModeBanner: false,
        home: const ProductListPage(),
      ),
    );
  }
}

