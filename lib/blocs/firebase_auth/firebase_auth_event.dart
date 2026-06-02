abstract class FirebaseAuthEvent {}

class FirebaseCheckAuthStatusEvent extends FirebaseAuthEvent {}

class FirebaseSignUpEvent extends FirebaseAuthEvent {
  final String email;
  final String password;

  FirebaseSignUpEvent({
    required this.email,
    required this.password,
  });
}

class FirebaseLoginEvent extends FirebaseAuthEvent {
  final String email;
  final String password;

  FirebaseLoginEvent({
    required this.email,
    required this.password,
  });
}

class FirebaseLogoutEvent extends FirebaseAuthEvent {}