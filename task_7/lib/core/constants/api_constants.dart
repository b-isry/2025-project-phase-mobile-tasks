/// API constants for the e-commerce app
/// 
/// Contains base URL and endpoint paths for remote API calls.
class ApiConstants {
  /// Base URL for the e-commerce API
  /// 
  /// In production, this should be configured via environment variables
  /// or a configuration file. For development, using a placeholder URL.
  static const String baseUrl = 'https://api.ecommerce.example.com/v1';
  
  /// Products endpoint path
  static const String productsEndpoint = '/products';
  
  /// Get full URL for products endpoint
  static String get productsUrl => '$baseUrl$productsEndpoint';
  
  /// Get URL for a specific product by ID
  static String productByIdUrl(String id) => '$baseUrl$productsEndpoint/$id';
}

