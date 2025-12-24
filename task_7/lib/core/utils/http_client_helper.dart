import 'dart:convert';
import 'package:http/http.dart' as http;
import '../error/exceptions.dart';

/// Helper class for common HTTP client operations
/// 
/// Provides reusable methods for:
/// - Making HTTP requests with consistent error handling
/// - Parsing responses
/// - Handling status codes
/// - Converting exceptions appropriately
class HttpClientHelper {
  /// Default JSON headers for API requests
  static const Map<String, String> jsonHeaders = {
    'Content-Type': 'application/json',
  };

  /// Executes a GET request and handles the response
  /// 
  /// Parameters:
  ///   - [client]: HTTP client instance
  ///   - [uri]: Request URI
  /// 
  /// Returns the HTTP response
  /// 
  /// Throws:
  ///   - [ServerException] for non-2xx responses
  ///   - [NetworkException] for network errors
  static Future<http.Response> get(
    http.Client client,
    Uri uri,
  ) async {
    try {
      final response = await client.get(uri);
      _handleResponse(response);
      return response;
    } on ServerException {
      rethrow;
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw NetworkException();
    }
  }

  /// Executes a POST request and handles the response
  /// 
  /// Parameters:
  ///   - [client]: HTTP client instance
  ///   - [uri]: Request URI
  ///   - [body]: Request body (will be JSON encoded)
  ///   - [headers]: Optional headers (defaults to JSON headers)
  /// 
  /// Returns the HTTP response
  /// 
  /// Throws:
  ///   - [ServerException] for non-2xx responses
  ///   - [NetworkException] for network errors
  static Future<http.Response> post(
    http.Client client,
    Uri uri, {
    Object? body,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await client.post(
        uri,
        headers: headers ?? jsonHeaders,
        body: body is String ? body : (body != null ? json.encode(body) : null),
      );
      _handleResponse(response);
      return response;
    } on ServerException {
      rethrow;
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw NetworkException();
    }
  }

  /// Executes a PUT request and handles the response
  /// 
  /// Parameters:
  ///   - [client]: HTTP client instance
  ///   - [uri]: Request URI
  ///   - [body]: Request body (will be JSON encoded)
  ///   - [headers]: Optional headers (defaults to JSON headers)
  /// 
  /// Returns the HTTP response
  /// 
  /// Throws:
  ///   - [ServerException] for non-2xx responses
  ///   - [NetworkException] for network errors
  static Future<http.Response> put(
    http.Client client,
    Uri uri, {
    Object? body,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await client.put(
        uri,
        headers: headers ?? jsonHeaders,
        body: body is String ? body : (body != null ? json.encode(body) : null),
      );
      _handleResponse(response);
      return response;
    } on ServerException {
      rethrow;
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw NetworkException();
    }
  }

  /// Executes a DELETE request and handles the response
  /// 
  /// Parameters:
  ///   - [client]: HTTP client instance
  ///   - [uri]: Request URI
  /// 
  /// Returns the HTTP response
  /// 
  /// Throws:
  ///   - [ServerException] for non-2xx responses
  ///   - [NetworkException] for network errors
  static Future<http.Response> delete(
    http.Client client,
    Uri uri,
  ) async {
    try {
      final response = await client.delete(uri);
      _handleResponse(response);
      return response;
    } on ServerException {
      rethrow;
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw NetworkException();
    }
  }

  /// Checks if a status code indicates success (2xx range)
  static bool isSuccessStatusCode(int statusCode) {
    return statusCode >= 200 && statusCode < 300;
  }

  /// Handles HTTP response and throws appropriate exceptions
  /// 
  /// Parameters:
  ///   - [response]: HTTP response to check
  ///   - [allowNotFound]: If true, 404 responses won't throw (default: false)
  /// 
  /// Throws [ServerException] for non-2xx responses (unless allowNotFound is true and status is 404)
  static void _handleResponse(
    http.Response response, {
    bool allowNotFound = false,
  }) {
    if (allowNotFound && response.statusCode == 404) {
      return;
    }

    if (!isSuccessStatusCode(response.statusCode)) {
      throw ServerException();
    }
  }

  /// Handles HTTP response with custom logic for 404 handling
  /// 
  /// This is a public method for cases where 404 should be handled differently
  static void handleResponseWithNotFound(
    http.Response response,
    void Function() onNotFound,
  ) {
    if (response.statusCode == 404) {
      onNotFound();
      return;
    }

    _handleResponse(response);
  }
}

