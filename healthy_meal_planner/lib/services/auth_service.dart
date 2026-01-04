// lib/services/auth_service.dart
import '../core/api_client.dart';
import '../models/user.dart';

class AuthService {
  final _client = ApiClient();

  Future<User> login(String email, String password) async {
    final res = await _client.post('auth/login.php', {'email': email, 'password': password});
    if (res['success'] == true) {
      return User.fromJson(res['data']['user']);
    }
    throw Exception(res['message'] ?? 'Login failed');
  }

  Future<bool> register(String name, String email, String password) async {
    final res = await _client.post('auth/register.php', {'name': name, 'email': email, 'password': password});
    return res['success'] == true;
  }
}
