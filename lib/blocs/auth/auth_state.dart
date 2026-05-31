abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String token;

  AuthSuccess(this.token);
}

class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);
}

class AuthUserLoaded extends AuthState {
  final Map<String, dynamic> userData;

  AuthUserLoaded(this.userData);
}