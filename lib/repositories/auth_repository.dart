// import '../services/auth_service.dart';

// class AuthRepository {
//   final AuthService authService;

//   AuthRepository(this.authService);

//   Future<String> login({//---it with return a string <String> and that string is the token
//     required String username,
//     required String password,
//   }) {
//     return authService.login(
//       username: username,
//       password: password,
//     );
//   }
// }
import 'package:shared_preferences/shared_preferences.dart';

import '../services/auth_service.dart';

class AuthRepository {
  final AuthService authService;

  AuthRepository(this.authService);

  Future<String> login({
    required String username,
    required String password,
  }) async {
    final token = await authService.login(
      username: username,
      password: password,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);

    return token;
  }

  Future<String?> getSavedToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    final token = await getSavedToken();

    if (token == null) {
      throw Exception('No token found');
    }

    final userData = await authService.getCurrentUser(token);

    return userData;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
}
