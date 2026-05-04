import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiException implements Exception {
  ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  factory ApiException.fromResponse(http.Response response) {
    return ApiException(
      _extractMessage(response.body, response.statusCode),
      statusCode: response.statusCode,
    );
  }

  static String _extractMessage(String body, int statusCode) {
    if (body.isNotEmpty) {
      try {
        final dynamic decoded = jsonDecode(body);
        if (decoded is Map<String, dynamic>) {
          final detail = decoded['detail'];
          if (detail is String && detail.trim().isNotEmpty) {
            return detail;
          }

          final message = decoded['message'];
          if (message is String && message.trim().isNotEmpty) {
            return message;
          }

          for (final value in decoded.values) {
            if (value is List && value.isNotEmpty && value.first is String) {
              return value.first as String;
            }
            if (value is String && value.trim().isNotEmpty) {
              return value;
            }
          }
        }
      } catch (_) {
        // Fall back to status-based messaging when the response isn't JSON.
      }
    }

    switch (statusCode) {
      case 400:
        return 'The request could not be processed. Please check your input.';
      case 401:
        return 'Your session has expired. Please log in again.';
      case 403:
        return 'You do not have permission to perform this action.';
      case 404:
        return 'The requested resource was not found.';
      case 500:
        return 'The server is having trouble right now. Please try again.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }

  @override
  String toString() => message;
}
