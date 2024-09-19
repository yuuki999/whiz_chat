import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/provider/api_service_provider.dart';
import '../api/auth_api.dart';
import '../entities/auth_token.dart';

class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final String? error;
  final AuthToken? token;

  AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.error,
    this.token,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    String? error,
    AuthToken? token,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      token: token ?? this.token,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthApi _authApi;

  AuthNotifier(this._authApi) : super(AuthState());

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final token = await _authApi.login(email, password);
      // TODO: ここでトークンをローカルストレージに保存する
      state = state.copyWith(
        isAuthenticated: true,
        isLoading: false,
        token: token,
      );
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'An unexpected error occurred');
    }
  }

// サインアウト機能などの他のメソッドもここに追加できます
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authApi = ref.watch(authApiProvider);
  return AuthNotifier(authApi);
});

final authApiProvider = Provider<AuthApi>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return AuthApi(apiService);
});