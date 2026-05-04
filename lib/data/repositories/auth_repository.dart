import 'package:vein_pay_wallet/core/network/api_exception.dart';
import 'package:vein_pay_wallet/core/session/session_manager.dart';
import 'package:vein_pay_wallet/core/storage/secure_storage_service.dart';
import 'package:vein_pay_wallet/data/services/auth_api_service.dart';

class AuthRepository {
  AuthRepository({
    required AuthApiService authApiService,
    required SecureStorageService secureStorageService,
    required SessionManager sessionManager,
  }) : _authApiService = authApiService,
       _secureStorageService = secureStorageService,
       _sessionManager = sessionManager;

  final AuthApiService _authApiService;
  final SecureStorageService _secureStorageService;
  final SessionManager _sessionManager;

  Future<void> restoreSession() async {
    final refreshToken = await _secureStorageService.readRefreshToken();
    if (refreshToken != null && refreshToken.isNotEmpty) {
      _sessionManager.setAuthenticated();
      return;
    }

    _sessionManager.setUnauthenticated();
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    final response = await _authApiService.login(
      username: username,
      password: password,
    );

    final refreshToken = response.refresh;
    if (response.access.isEmpty ||
        refreshToken == null ||
        refreshToken.isEmpty) {
      throw ApiException('Unable to start your session. Please try again.');
    }

    await _secureStorageService.saveTokens(
      accessToken: response.access,
      refreshToken: refreshToken,
    );
    _sessionManager.setAuthenticated();
  }

  Future<void> logout() async {
    await _secureStorageService.clearTokens();
    _sessionManager.setUnauthenticated();
  }

  Future<void> handleSessionExpired() async {
    await _secureStorageService.clearTokens();
    _sessionManager.setUnauthenticated();
  }
}
