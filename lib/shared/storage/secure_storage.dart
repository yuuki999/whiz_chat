import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// セキュアなデータをローカルに保存するために使用
// 例) JWTトークン、認証まわり
class SecureStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _tokenKey = 'auth_tokens';

  // アクセストークンとリフレッシュトークンを保存
  static Future<void> storeTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    final authTokens = {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
    await _storage.write(key: _tokenKey, value: json.encode(authTokens));
  }

  // 保存されているトークンを取得
  static Future<Map<String, dynamic>?> getTokens() async {
    final tokensJson = await _storage.read(key: _tokenKey);
    if (tokensJson == null) return null;
    return json.decode(tokensJson);
  }

  // アクセストークンのみを取得
  static Future<String?> getAccessToken() async {
    final tokens = await getTokens();
    return tokens?['accessToken'];
  }

  // リフレッシュトークンのみを取得
  static Future<String?> getRefreshToken() async {
    final tokens = await getTokens();
    return tokens?['refreshToken'];
  }

  // 全てのトークンの削除（ログアウト時など）
  static Future<void> deleteAllTokens() async {
    await _storage.delete(key: _tokenKey);
  }
}