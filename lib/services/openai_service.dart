import 'dart:convert';
import '../network/network_utills.dart';
import '../extensions/extension_util/int_extensions.dart';
import 'package:http/http.dart' as http;

class OpenAIService {
  /// Extract error message from response
  String _extractErrorMessage(dynamic error, http.Response? response) {
    try {
      // If error is a string, return it directly
      if (error is String) {
        return error;
      }

      // If we have a response, try to parse it
      if (response != null && response.body.isNotEmpty) {
        try {
          final errorData = jsonDecode(response.body) as Map<String, dynamic>;

          // Check for validation errors (422)
          if (errorData.containsKey('errors') && errorData['errors'] is Map) {
            final errors = errorData['errors'] as Map<String, dynamic>;
            // Get first error message
            if (errors.isNotEmpty) {
              final firstError = errors.values.first;
              if (firstError is List && firstError.isNotEmpty) {
                return firstError.first.toString();
              } else if (firstError is String) {
                return firstError;
              }
            }
          }

          // Check for message field
          if (errorData.containsKey('message')) {
            return errorData['message'].toString();
          }
        } catch (e) {
          // If parsing fails, continue to default error
        }
      }
    } catch (e) {
      // Fall through to default error
    }

    // Default error message
    return error.toString();
  }

  /// Get corrected description (no mistakes, same context)
  Future<String> getCorrectedDescription(String description) async {
    http.Response? response;
    try {
      response = await buildHttpResponse(
        'property-description/correct',
        method: HttpMethod.POST,
        request: {
          'description': description,
        },
      );

      final data = await handleResponse(response);

      // Handle response structure - adjust based on your backend response format
      if (data is Map<String, dynamic>) {
        // If backend returns { "description": "..." } or { "data": "..." } or just { "result": "..." }
        return data['description'] ??
            data['data'] ??
            data['result'] ??
            data['content'] ??
            data.toString();
      } else if (data is String) {
        return data;
      } else {
        throw Exception('Unexpected response format: $data');
      }
    } catch (e) {
      final errorMessage = _extractErrorMessage(e, response);
      throw Exception(errorMessage);
    }
  }

  /// Get enhanced description (improved and polished)
  Future<String> getEnhancedDescription(String description) async {
    http.Response? response;
    try {
      response = await buildHttpResponse(
        'property-description/enhance',
        method: HttpMethod.POST,
        request: {
          'description': description,
        },
      );

      final data = await handleResponse(response);

      // Handle response structure - adjust based on your backend response format
      if (data is Map<String, dynamic>) {
        return data['description'] ??
            data['data'] ??
            data['result'] ??
            data['content'] ??
            data.toString();
      } else if (data is String) {
        return data;
      } else {
        throw Exception('Unexpected response format: $data');
      }
    } catch (e) {
      final errorMessage = _extractErrorMessage(e, response);
      throw Exception(errorMessage);
    }
  }

  /// Get description with opinion (professional opinion/suggestions)
  Future<String> getDescriptionWithOpinion(String description) async {
    http.Response? response;
    try {
      response = await buildHttpResponse(
        'property-description/with-opinion',
        method: HttpMethod.POST,
        request: {
          'description': description,
        },
      );

      final data = await handleResponse(response);

      // Handle response structure - adjust based on your backend response format
      if (data is Map<String, dynamic>) {
        return data['description'] ??
            data['data'] ??
            data['result'] ??
            data['content'] ??
            data.toString();
      } else if (data is String) {
        return data;
      } else {
        throw Exception('Unexpected response format: $data');
      }
    } catch (e) {
      final errorMessage = _extractErrorMessage(e, response);
      throw Exception(errorMessage);
    }
  }

  /// Get all three options at once
  Future<Map<String, String>> getAllOptions(String description) async {
    http.Response? response;
    try {
      response = await buildHttpResponse(
        'property-description/all',
        method: HttpMethod.POST,
        request: {
          'description': description,
        },
      );

      // Check if response has error status code before handling
      if (!response.statusCode.isSuccessful()) {
        final errorMessage = _extractErrorMessage(null, response);
        throw Exception(errorMessage);
      }

      final data = await handleResponse(response);

      // Handle response structure - adjust based on your backend response format
      // Expected format: { "corrected": "...", "enhanced": "...", "withOpinion": "..." }
      if (data is Map<String, dynamic>) {
        // Check if data is nested in 'data' key
        Map<String, dynamic> responseData = data;
        if (data['data'] is Map<String, dynamic>) {
          responseData = data['data'] as Map<String, dynamic>;
        }

        return {
          'corrected': responseData['corrected'] ??
              responseData['corrected_description'] ??
              '',
          'enhanced': responseData['enhanced'] ??
              responseData['enhanced_description'] ??
              '',
          'withOpinion': responseData['with_opinion'] ??
              responseData['withOpinion'] ??
              responseData['opinion'] ??
              '',
        };
      } else {
        throw Exception('Unexpected response format: $data');
      }
    } catch (e) {
      final errorMessage = _extractErrorMessage(e, response);
      throw Exception(errorMessage);
    }
  }
}
