import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final Dio _dio;
  final String _baseUrl;

  ApiService(this._dio) : _baseUrl = dotenv.env["API_BASE_URL"]!;

  Future<Response> request({
    required String endpoint,
    required String method,
    bool requiresAuth = true,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final fullPath = '$_baseUrl$endpoint';
    final options = Options(method: method);

    // APIに認証が必要な場合
    if (requiresAuth) {
      final token = await _getToken();
      options.headers = {
        ...options.headers ?? {},
        'Authorization': 'Bearer $token',
      };
    }

    try {
      return await _dio.request(
        fullPath,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      print('APIリクエストでエラー: $e');
      rethrow;
    }
  }

  Future<String> _getToken() async {
    // トークン取得ロジックを実装
    // 例: セキュアストレージから取得

    // TODO: JWTトークンをセットしておいて、それを取得する処理。
    return 'your_token_here';
  }

  // TODO: JWTセットも必要では？
}
