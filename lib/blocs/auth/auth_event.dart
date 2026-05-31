abstract class AuthEvent {}

class LoginRequestedEvent extends AuthEvent {
  final String username;
  final String password;

  LoginRequestedEvent({
    required this.username,
    required this.password,
  });
}
class CheckAuthStatusEvent extends AuthEvent {}
class LogoutRequestedEvent extends AuthEvent {}
class GetCurrentUserEvent extends AuthEvent {}