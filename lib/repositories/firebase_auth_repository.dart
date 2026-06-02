import 'package:firebase_auth/firebase_auth.dart';

import '../services/firebase_auth_service.dart';

class FirebaseAuthRepository {
  final FirebaseAuthService firebaseAuthService;

  FirebaseAuthRepository(this.firebaseAuthService);

  Future<User?> signUp({
    required String email,
    required String password,
  }) async {
    final user = await firebaseAuthService.signUp(
      email: email,
      password: password,
    );

    return user;
  }

  Future<User?> login({
    required String email,
    required String password,
  }) async {
    final user = await firebaseAuthService.login(
      email: email,
      password: password,
    );

    return user;
  }

  Future<void> logout() async {
    await firebaseAuthService.logout();
  }

  User? getCurrentUser() {
    return firebaseAuthService.getCurrentUser();
  }
}