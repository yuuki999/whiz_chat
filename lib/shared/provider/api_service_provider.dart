import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/api_service.dart';
import 'dio_provider.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiService(dio);
});