import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<LoginRequestedEvent>(_onLoginRequested);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<LogoutRequestedEvent>(_onLogoutRequested);
    on<GetCurrentUserEvent>(_onGetCurrentUser);
  }

  Future<void> _onLoginRequested(
    LoginRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final token = await authRepository.login(
        username: event.username,
        password: event.password,
      );

      emit(AuthSuccess(token));
    } catch (error) {
      emit(
        AuthFailure('Login failed. Please check your username and password.'),
      );
    }
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    final token = await authRepository.getSavedToken();

    if (token == null) {
      emit(AuthInitial());
    } else {
      emit(AuthSuccess(token));
    }
  }

  Future<void> _onLogoutRequested(
  LogoutRequestedEvent event,
  Emitter<AuthState> emit,
) async {
  await authRepository.logout();

  emit(AuthInitial());
}

Future<void> _onGetCurrentUser(
  GetCurrentUserEvent event,
  Emitter<AuthState> emit,
) async {
  //emit(AuthLoading());

  try {
    final userData = await authRepository.getCurrentUser();

    emit(AuthUserLoaded(userData));
  } catch (error) {
    emit(AuthFailure('Failed to get current user'));
  }
}

}
