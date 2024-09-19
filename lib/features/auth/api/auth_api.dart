import '../../../shared/api/api_service.dart';
import '../../../shared/api/api_endpoints.dart';
import '../../../shared/storage/secure_storage.dart';
import '../entities/auth_token.dart';

class AuthApi {
  final ApiService _apiService;

  AuthApi(this._apiService);

  Future<AuthToken> login(String email, String password) async {
    try {
      final response = await _apiService.request(
        endpoint: ApiEndpoints.login,
        method: 'POST',
        requiresAuth: false,
        data: {'email': email, 'password': password},
      );

      final authToken = AuthToken.fromJson(response.data);
      // jwtトークンを保存
      await SecureStorage.storeTokens(
        accessToken: authToken.accessToken,
        refreshToken: authToken.refreshToken,
      );

      return authToken;

    } catch (e) {
      throw AuthException('ログインに失敗しました : ${e.toString()}');
    }
  }

  // Future<void> logout() async {
  //   try {
  //     await _apiService.request(
  //       endpoint: ApiEndpoints.logout,
  //       method: 'POST',
  //       requiresAuth: true,
  //     );
  //   } catch (e) {
  //     throw AuthException('Logout failed: ${e.toString()}');
  //   }
  // }

  // Future<AuthToken> refreshToken(String refreshToken) async {
  //   try {
  //     final response = await _apiService.request(
  //       endpoint: ApiEndpoints.refreshToken,
  //       method: 'POST',
  //       requiresAuth: false,
  //       data: {'refreshToken': refreshToken},
  //     );
  //
  //     return AuthToken.fromJson(response.data);
  //   } catch (e) {
  //     throw AuthException('Token refresh failed: ${e.toString()}');
  //   }
  // }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}