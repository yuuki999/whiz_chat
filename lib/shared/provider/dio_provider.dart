import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: dotenv.env['API_BASE_URL']!,
    connectTimeout: Duration(milliseconds: int.parse(dotenv.env['API_TIMEOUT']!)),
    receiveTimeout: Duration(milliseconds: int.parse(dotenv.env['API_TIMEOUT']!)),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  // リクエストエラー時に実行
  dio.interceptors.add(InterceptorsWrapper(
    onError: (DioException e, ErrorInterceptorHandler handler) {
      // エラーハンドリングのロジック
      print('DIO ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}');
      return handler.next(e);
    },
  ));

  // リクエスト前に実行
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
      // ここで認証トークンを追加するなどの処理を行う
      // options.headers['Authorization'] = 'Bearer ${getToken()}';
      return handler.next(options);
    },
  ));

  // レスポンスを受け取った後に実行
  dio.interceptors.add(InterceptorsWrapper(
    onResponse: (Response response, ResponseInterceptorHandler handler) {
      // レスポンスの加工や検証を行う場合はここで実装
      return handler.next(response);
    },
  ));

  return dio;
});