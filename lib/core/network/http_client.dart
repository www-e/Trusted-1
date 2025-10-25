// HTTP Client Wrapper - Handles all HTTP requests with automatic retry, timeout, and auth
// Provides centralized request/response handling with error mapping

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import '../config/env.dart';
import '../storage/secure_storage_service.dart';
import 'api_exceptions.dart';

class HttpClient {
  final http.Client _client;
  final SecureStorageService _storage;
  final Connectivity _connectivity;

  HttpClient({
    http.Client? client,
    required SecureStorageService storage,
    Connectivity? connectivity,
  })  : _client = client ?? http.Client(),
        _storage = storage,
        _connectivity = connectivity ?? Connectivity();

  /// Make a GET request
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? headers,
    bool requiresAuth = false,
  }) async {
    return _makeRequest(
      method: 'GET',
      endpoint: endpoint,
      headers: headers,
      requiresAuth: requiresAuth,
    );
  }

  /// Make a POST request
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    bool requiresAuth = false,
  }) async {
    return _makeRequest(
      method: 'POST',
      endpoint: endpoint,
      body: body,
      headers: headers,
      requiresAuth: requiresAuth,
    );
  }

  /// Make a PUT request
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    bool requiresAuth = false,
  }) async {
    return _makeRequest(
      method: 'PUT',
      endpoint: endpoint,
      body: body,
      headers: headers,
      requiresAuth: requiresAuth,
    );
  }

  /// Make a DELETE request
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, String>? headers,
    bool requiresAuth = false,
  }) async {
    return _makeRequest(
      method: 'DELETE',
      endpoint: endpoint,
      headers: headers,
      requiresAuth: requiresAuth,
    );
  }

  /// Core request method with retry logic and error handling
  Future<Map<String, dynamic>> _makeRequest({
    required String method,
    required String endpoint,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    bool requiresAuth = false,
    int retryCount = 0,
  }) async {
    // Check connectivity
    await _checkConnectivity();

    // Build URL
    final url = Uri.parse('${AppConfig.baseUrl}/$endpoint');

    // Build headers
    final requestHeaders = await _buildHeaders(headers, requiresAuth);

    // Check token expiration if auth is required
    if (requiresAuth) {
      await _checkTokenExpiration();
    }

    try {
      http.Response response;

      // Make request with timeout
      final timeout = Duration(seconds: AppConfig.timeoutSeconds);

      switch (method) {
        case 'GET':
          response = await _client.get(url, headers: requestHeaders).timeout(
                timeout,
                onTimeout: () => throw TimeoutException(),
              );
          break;
        case 'POST':
          response = await _client
              .post(
                url,
                headers: requestHeaders,
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(
                timeout,
                onTimeout: () => throw TimeoutException(),
              );
          break;
        case 'PUT':
          response = await _client
              .put(
                url,
                headers: requestHeaders,
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(
                timeout,
                onTimeout: () => throw TimeoutException(),
              );
          break;
        case 'DELETE':
          response = await _client.delete(url, headers: requestHeaders).timeout(
                timeout,
                onTimeout: () => throw TimeoutException(),
              );
          break;
        default:
          throw ApiException(message: 'Unsupported HTTP method: $method');
      }

      return _handleResponse(response);
    } on SocketException {
      // Network error - retry with exponential backoff
      if (retryCount < AppConfig.maxRetries) {
        await Future.delayed(Duration(seconds: (retryCount + 1) * 2));
        return _makeRequest(
          method: method,
          endpoint: endpoint,
          body: body,
          headers: headers,
          requiresAuth: requiresAuth,
          retryCount: retryCount + 1,
        );
      }
      throw NetworkException();
    } on TimeoutException {
      // Timeout - retry with exponential backoff
      if (retryCount < AppConfig.maxRetries) {
        await Future.delayed(Duration(seconds: (retryCount + 1) * 2));
        return _makeRequest(
          method: method,
          endpoint: endpoint,
          body: body,
          headers: headers,
          requiresAuth: requiresAuth,
          retryCount: retryCount + 1,
        );
      }
      throw TimeoutException();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'حدث خطأ غير متوقع', details: e.toString());
    }
  }

  /// Build request headers
  Future<Map<String, String>> _buildHeaders(
    Map<String, String>? customHeaders,
    bool requiresAuth,
  ) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Add custom headers
    if (customHeaders != null) {
      headers.addAll(customHeaders);
    }

    // Add authorization header if required
    if (requiresAuth) {
      final token = await _storage.read(AppConfig.storageKeyToken);
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  /// Check internet connectivity
  Future<void> _checkConnectivity() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      throw NetworkException();
    }
  }

  /// Check if token is expired and throw exception if it is
  Future<void> _checkTokenExpiration() async {
    final expiryStr = await _storage.read(AppConfig.storageKeyTokenExpiry);
    if (expiryStr == null) return;

    try {
      final expiryDate = DateTime.parse(expiryStr);
      final now = DateTime.now();

      // Check if token is expired or about to expire
      if (now.isAfter(expiryDate)) {
        throw TokenExpiredException();
      }

      // Check if token is about to expire (within margin)
      final difference = expiryDate.difference(now).inSeconds;
      if (difference < AppConfig.tokenExpirationMargin) {
        // Token is about to expire - throw exception to force re-login
        // In a real app, you would implement refresh token logic here
        throw TokenExpiredException();
      }
    } catch (e) {
      if (e is TokenExpiredException) rethrow;
      // If parsing fails, continue with request
    }
  }

  /// Handle HTTP response and map errors
  Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      // Check for tRPC error structure
      if (data.containsKey('error')) {
        final error = data['error'] as Map<String, dynamic>;
        final errorCode = error['code'] as String?;
        final errorMessage = error['message'] as String?;

        throw _mapErrorToException(
          errorCode ?? 'UNKNOWN',
          errorMessage ?? 'خطأ غير معروف',
          response.statusCode,
        );
      }

      // Success - return data
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return data;
      }

      // Unexpected status code
      throw ApiException(
        message: 'خطأ في الخادم',
        statusCode: response.statusCode,
      );
    } on FormatException {
      throw ParseException(details: response.body);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ParseException(details: e.toString());
    }
  }

  /// Map error code to exception
  ApiException _mapErrorToException(
    String errorCode,
    String message,
    int statusCode,
  ) {
    switch (errorCode) {
      case 'UNAUTHORIZED':
        return UnauthorizedException(message: message);
      case 'CONFLICT':
        return ConflictException(message: message);
      case 'NOT_FOUND':
        return NotFoundException(message: message);
      case 'BAD_REQUEST':
        return BadRequestException(message: message);
      case 'INTERNAL_SERVER_ERROR':
        return InternalServerException(message: message);
      default:
        return ApiException(
          message: message,
          statusCode: statusCode,
          errorCode: errorCode,
        );
    }
  }

  /// Dispose client
  void dispose() {
    _client.close();
  }
}
