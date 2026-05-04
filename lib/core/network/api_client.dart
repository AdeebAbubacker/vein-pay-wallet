import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:vein_pay_wallet/core/constants/api_constants.dart';
import 'package:vein_pay_wallet/core/network/api_exception.dart';
import 'package:vein_pay_wallet/core/storage/secure_storage_service.dart';

class ApiClient {
  ApiClient({
    required http.Client httpClient,
    required SecureStorageService secureStorageService,
    Future<void> Function()? onSessionExpired,
  }) : _httpClient = httpClient,
       _secureStorageService = secureStorageService,
       _onSessionExpired = onSessionExpired;

  final http.Client _httpClient;
  final SecureStorageService _secureStorageService;
  final Future<void> Function()? _onSessionExpired;

  Future<String?>? _refreshFuture;

  Future<http.Response> get(
    String endpoint, {
    Map<String, String>? headers,
    bool requiresAuth = true,
  }) {
    return _sendRequest(
      method: 'GET',
      endpoint: endpoint,
      headers: headers,
      requiresAuth: requiresAuth,
    );
  }

  Future<http.Response> post(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) {
    return _sendRequest(
      method: 'POST',
      endpoint: endpoint,
      headers: headers,
      body: body,
      requiresAuth: requiresAuth,
    );
  }

  Future<http.Response> _sendRequest({
    required String method,
    required String endpoint,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    required bool requiresAuth,
    bool allowRetry = true,
  }) async {
    try {
      if (requiresAuth) {
        final currentAccessToken = await _secureStorageService
            .readAccessToken();
        if (currentAccessToken == null || currentAccessToken.isEmpty) {
          final refreshedToken = await _refreshAccessToken();
          if (refreshedToken == null || refreshedToken.isEmpty) {
            await _expireSession();
            throw ApiException(
              'Your session has expired. Please log in again.',
              statusCode: 401,
            );
          }
        }
      }

      final requestHeaders = await _buildHeaders(
        headers: headers,
        requiresAuth: requiresAuth,
        hasBody: body != null,
      );

      final response = await _performRequest(
        method: method,
        endpoint: endpoint,
        headers: requestHeaders,
        body: body,
      );

      if (response.statusCode == 401 && requiresAuth && allowRetry) {
        final refreshedToken = await _refreshAccessToken();
        if (refreshedToken == null || refreshedToken.isEmpty) {
          await _expireSession();
          throw ApiException(
            'Your session has expired. Please log in again.',
            statusCode: 401,
          );
        }

        return _sendRequest(
          method: method,
          endpoint: endpoint,
          headers: headers,
          body: body,
          requiresAuth: requiresAuth,
          allowRetry: false,
        );
      }

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiException.fromResponse(response);
      }

      return response;
    } on SocketException {
      throw ApiException(
        'Unable to reach the server. Please check your connection and try again.',
      );
    } on http.ClientException {
      throw ApiException(
        'A network error occurred. Please try again in a moment.',
      );
    } on FormatException {
      throw ApiException(
        'We received an unexpected response from the server. Please try again.',
      );
    }
  }

  Future<Map<String, String>> _buildHeaders({
    Map<String, String>? headers,
    required bool requiresAuth,
    required bool hasBody,
  }) async {
    final mergedHeaders = <String, String>{...?headers};

    if (hasBody && !mergedHeaders.containsKey(HttpHeaders.contentTypeHeader)) {
      mergedHeaders[HttpHeaders.contentTypeHeader] = 'application/json';
    }

    if (requiresAuth) {
      final accessToken = await _secureStorageService.readAccessToken();
      if (accessToken != null && accessToken.isNotEmpty) {
        mergedHeaders[HttpHeaders.authorizationHeader] = 'Bearer $accessToken';
      }
    }

    return mergedHeaders;
  }

  Future<http.Response> _performRequest({
    required String method,
    required String endpoint,
    required Map<String, String> headers,
    Map<String, dynamic>? body,
  }) {
    final uri = ApiConstants.buildUri(endpoint);

    switch (method) {
      case 'GET':
        return _httpClient.get(uri, headers: headers);
      case 'POST':
        return _httpClient.post(
          uri,
          headers: headers,
          body: body == null ? null : jsonEncode(body),
        );
      default:
        throw ApiException('Unsupported HTTP method: $method');
    }
  }

  Future<String?> _refreshAccessToken() async {
    final existingRefresh = _refreshFuture;
    if (existingRefresh != null) {
      return existingRefresh;
    }

    final refreshFuture = _refreshAccessTokenInternal();
    _refreshFuture = refreshFuture;

    try {
      return await refreshFuture;
    } finally {
      _refreshFuture = null;
    }
  }

  Future<String?> _refreshAccessTokenInternal() async {
    final refreshToken = await _secureStorageService.readRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return null;
    }

    final response = await _httpClient.post(
      ApiConstants.buildUri(ApiConstants.refreshToken),
      headers: const {HttpHeaders.contentTypeHeader: 'application/json'},
      body: jsonEncode(<String, dynamic>{'refresh': refreshToken}),
    );

    if (response.statusCode != 200) {
      return null;
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final accessToken = decoded['access']?.toString();

    if (accessToken == null || accessToken.isEmpty) {
      return null;
    }

    await _secureStorageService.saveAccessToken(accessToken);
    return accessToken;
  }

  Future<void> _expireSession() async {
    await _secureStorageService.clearTokens();
    await _onSessionExpired?.call();
  }
}
