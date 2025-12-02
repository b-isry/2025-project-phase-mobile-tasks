import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/product_view_screen.dart';
import 'screens/product_edit_screen.dart';

/// ROUTING: Central route configuration with named routes
class Routes {
  static const String home = '/';
  static const String productView = '/product';
  static const String productEdit = '/edit';

  /// Define static routes
  static Map<String, WidgetBuilder> get routes => {
        home: (context) => const HomeScreen(),
      };

  /// ROUTING: Custom route generator with transitions
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case productView:
        return _buildSlideTransition(
          settings: settings,
          child: const ProductViewScreen(),
        );
      case productEdit:
        return _buildSlideTransition(
          settings: settings,
          child: const ProductEditScreen(),
        );
      default:
        return null;
    }
  }

  /// Build a smooth slide + fade transition from right to left
  static PageRouteBuilder _buildSlideTransition({
    required RouteSettings settings,
    required Widget child,
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Slide from right transition
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var slideTween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        var offsetAnimation = animation.drive(slideTween);

        // Add fade transition for smoother effect
        var fadeTween = Tween(begin: 0.0, end: 1.0).chain(
          CurveTween(curve: curve),
        );

        var fadeAnimation = animation.drive(fadeTween);

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}

/// ROUTING: Arguments for ProductViewScreen
class ProductViewArguments {
  final String productId;

  ProductViewArguments({required this.productId});
}

/// ROUTING: Arguments for ProductEditScreen
class ProductEditArguments {
  final String? productId; // null for add mode, non-null for edit mode

  ProductEditArguments({this.productId});

  bool get isEditMode => productId != null;
}

