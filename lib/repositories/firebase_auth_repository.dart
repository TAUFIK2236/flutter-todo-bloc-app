import 'package:firebase_auth/firebase_auth.dart';

import '../services/firebase_auth_service.dart';
import '../services/firestore_service.dart';

class FirebaseAuthRepository {
  final FirebaseAuthService firebaseAuthService;
  final FirestoreService firestoreService;

  FirebaseAuthRepository({
    required this.firebaseAuthService,
    required this.firestoreService,
  });

  //----------------------------------------------------------------------------------------------------------------------
  Future<User?> signUp({
    required String email,
    required String password,
  }) async {
    final user = await firebaseAuthService.signUp(
      email: email,
      password: password,
    );

    if (user != null && user.email != null) {
      await firestoreService.saveUserProfile(
        userId: user.uid,
        email: user.email!,
      );
    }

    return user;
  }

  //----------------------------------------------------------------------------------------------------------------------
  Future<User?> login({required String email, required String password}) async {
    final user = await firebaseAuthService.login(
      email: email,
      password: password,
    );

    return user;
  }

  //----------------------------------------------------------------------------------------------------------------------
  Future<void> logout() async {
    await firebaseAuthService.logout();
  }

  //----------------------------------------------------------------------------------------------------------------------
  User? getCurrentUser() {
    return firebaseAuthService.getCurrentUser();
  }

  //----------------------------------------------------------------------------------------------------------------------
  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    final user = firebaseAuthService.getCurrentUser();
    if (user == null) {
      throw Exception('No user is logged in');
    }
    final profileData = await firestoreService.getUserProfile(userId: user.uid);
    return profileData;
  }
}
