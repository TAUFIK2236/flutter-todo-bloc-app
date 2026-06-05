import 'package:firebase_auth/firebase_auth.dart';

abstract class FirebaseAuthState {}

//----------------------------------------------------------------------------------------------------------------------
class FirebaseAuthInitial extends FirebaseAuthState {}

//----------------------------------------------------------------------------------------------------------------------
class FirebaseAuthLoading extends FirebaseAuthState {}

//----------------------------------------------------------------------------------------------------------------------
class FirebaseAuthSuccess extends FirebaseAuthState {
  final User user;

  FirebaseAuthSuccess(this.user);
}

//----------------------------------------------------------------------------------------------------------------------
class FirebaseAuthFailure extends FirebaseAuthState {
  final String message;

  FirebaseAuthFailure(this.message);
}

//----------------------------------------------------------------------------------------------------------------------
class FirebaseUserProfileLoaded extends FirebaseAuthState {
  final Map<String, dynamic> profileData;

  FirebaseUserProfileLoaded(this.profileData);
}
