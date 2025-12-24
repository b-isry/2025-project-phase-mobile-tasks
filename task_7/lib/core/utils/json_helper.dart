import 'dart:convert';
import '../error/exceptions.dart';

/// Helper class for JSON serialization and deserialization operations
/// 
/// Provides reusable methods for:
/// - Safe JSON encoding/decoding
/// - Converting between JSON and domain entities
/// - Handling JSON parsing errors
class JsonHelper {
  /// Safely decodes a JSON string to a Map
  /// 
  /// Parameters:
  ///   - [jsonString]: JSON string to decode
  /// 
  /// Returns the decoded Map
  /// 
  /// Throws [ServerException] if decoding fails
  static Map<String, dynamic> decodeMap(String jsonString) {
    try {
      return json.decode(jsonString) as Map<String, dynamic>;
    } on FormatException {
      throw ServerException();
    } catch (e) {
      throw ServerException();
    }
  }

  /// Safely decodes a JSON string to a List
  /// 
  /// Parameters:
  ///   - [jsonString]: JSON string to decode
  /// 
  /// Returns the decoded List
  /// 
  /// Throws [ServerException] if decoding fails
  static List<dynamic> decodeList(String jsonString) {
    try {
      return json.decode(jsonString) as List<dynamic>;
    } on FormatException {
      throw ServerException();
    } catch (e) {
      throw ServerException();
    }
  }

  /// Safely encodes an object to a JSON string
  /// 
  /// Parameters:
  ///   - [object]: Object to encode (must be JSON-serializable)
  /// 
  /// Returns the JSON string
  /// 
  /// Throws [ServerException] if encoding fails
  static String encode(Object object) {
    try {
      return json.encode(object);
    } catch (e) {
      throw ServerException();
    }
  }

  /// Converts a list of JSON maps to a list of domain entities
  /// 
  /// Parameters:
  ///   - [jsonList]: List of JSON maps
  ///   - [fromJson]: Function to convert JSON map to entity
  /// 
  /// Returns a list of entities
  /// 
  /// Throws [ServerException] if conversion fails
  static List<T> fromJsonList<T>(
    List<dynamic> jsonList,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    try {
      return jsonList
          .map((json) => fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException();
    }
  }

  /// Converts a list of entities to a list of JSON strings
  /// 
  /// Parameters:
  ///   - [entities]: List of entities with toJson method
  /// 
  /// Returns a list of JSON strings
  static List<String> toJsonStringList<T extends Object>(
    List<T> entities,
    Map<String, dynamic> Function(T) toJson,
  ) {
    return entities.map((entity) => encode(toJson(entity))).toList();
  }
}

