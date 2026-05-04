import 'dart:convert';

import 'package:vein_pay_wallet/core/constants/api_constants.dart';
import 'package:vein_pay_wallet/core/network/api_client.dart';
import 'package:vein_pay_wallet/data/models/login_response_model.dart';

class AuthApiService {
  AuthApiService(this._apiClient);

  final ApiClient _apiClient;

  Future<LoginResponseModel> login({
    required String username,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.login,
      requiresAuth: false,
      body: <String, dynamic>{'username': username, 'password': password},
    );

    return LoginResponseModel.fromJson(
      Map<String, dynamic>.from(jsonDecode(response.body) as Map),
    );
  }

  Future<LoginResponseModel> refreshToken(String refreshToken) async {
    final response = await _apiClient.post(
      ApiConstants.refreshToken,
      requiresAuth: false,
      body: <String, dynamic>{'refresh': refreshToken},
    );

    return LoginResponseModel.fromJson(
      Map<String, dynamic>.from(jsonDecode(response.body) as Map),
    );
  }
}
