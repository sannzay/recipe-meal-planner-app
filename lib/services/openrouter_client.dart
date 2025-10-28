import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../config/api_config.dart';
import '../models/ai_models.dart';

class OpenRouterClient {
  final http.Client _httpClient;
  
  OpenRouterClient({http.Client? httpClient}) 
      : _httpClient = httpClient ?? http.Client();

  Future<OpenRouterResponse> sendRequest(OpenRouterRequest request) async {
    try {
      final url = Uri.parse('${ApiConfig.openRouterBaseUrl}/chat/completions');
      
      if (kDebugMode) {
        print('[OpenRouter] Sending request to: $url');
        print('[OpenRouter] Model: ${request.model}');
      }

      final response = await _httpClient
          .post(
            url,
            headers: ApiConfig.getHeaders(),
            body: jsonEncode(request.toJson()),
          )
          .timeout(
            Duration(seconds: ApiConfig.requestTimeoutSeconds),
            onTimeout: () {
              throw TimeoutException('Request timed out after ${ApiConfig.requestTimeoutSeconds} seconds');
            },
          );

      if (kDebugMode) {
        print('[OpenRouter] Response status: ${response.statusCode}');
        if (response.statusCode != 200) {
          print('[OpenRouter] Error response body: ${response.body}');
        }
      }

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return OpenRouterResponse.fromJson(jsonResponse);
      } else if (response.statusCode == 429) {
        throw RateLimitException('Rate limit exceeded. Please try again later.');
      } else if (response.statusCode == 401) {
        throw AuthenticationException('Invalid API key. Please check your OpenRouter API key in lib/config/api_config.dart');
      } else if (response.statusCode == 402) {
        throw InsufficientCreditsException('Insufficient credits. Please check your OpenRouter balance.');
      } else {
        final errorBody = response.body;
        if (kDebugMode) {
          print('[OpenRouter] Error response: $errorBody');
        }
        throw ApiException('API request failed with status ${response.statusCode}');
      }
    } on TimeoutException {
      rethrow;
    } on http.ClientException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    } catch (e) {
      if (e is ApiException || 
          e is RateLimitException || 
          e is AuthenticationException ||
          e is InsufficientCreditsException) {
        rethrow;
      }
      throw ApiException('Unexpected error: ${e.toString()}');
    }
  }

  void dispose() {
    _httpClient.close();
  }
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);
  
  @override
  String toString() => message;
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  
  @override
  String toString() => message;
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
  
  @override
  String toString() => message;
}

class RateLimitException implements Exception {
  final String message;
  RateLimitException(this.message);
  
  @override
  String toString() => message;
}

class AuthenticationException implements Exception {
  final String message;
  AuthenticationException(this.message);
  
  @override
  String toString() => message;
}

class InsufficientCreditsException implements Exception {
  final String message;
  InsufficientCreditsException(this.message);
  
  @override
  String toString() => message;
}

