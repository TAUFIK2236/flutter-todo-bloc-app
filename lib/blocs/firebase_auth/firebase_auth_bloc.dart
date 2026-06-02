import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/firebase_auth_repository.dart';
import 'firebase_auth_event.dart';
import 'firebase_auth_state.dart';

class FirebaseAuthBloc
    extends Bloc<FirebaseAuthEvent, FirebaseAuthState> {
  final FirebaseAuthRepository repository;

  FirebaseAuthBloc(this.repository) : super(FirebaseAuthInitial()) {
    on<FirebaseCheckAuthStatusEvent>(_onCheckAuthStatus);
    on<FirebaseSignUpEvent>(_onSignUp);
    on<FirebaseLoginEvent>(_onLogin);
    on<FirebaseLogoutEvent>(_onLogout);
  }

  void _onCheckAuthStatus(
    FirebaseCheckAuthStatusEvent event,
    Emitter<FirebaseAuthState> emit,
  ) {
    final user = repository.getCurrentUser();

    if (user == null) {
      emit(FirebaseAuthInitial());
    } else {
      emit(FirebaseAuthSuccess(user));
    }
  }

  Future<void> _onSignUp(
    FirebaseSignUpEvent event,
    Emitter<FirebaseAuthState> emit,
  ) async {
    emit(FirebaseAuthLoading());

    try {
      final user = await repository.signUp(
        email: event.email,
        password: event.password,
      );

      if (user == null) {
        emit(FirebaseAuthFailure('Signup failed'));
      } else {
        emit(FirebaseAuthSuccess(user));
      }
    } catch (error) {
      emit(FirebaseAuthFailure(error.toString()));
    }
  }

  Future<void> _onLogin(
    FirebaseLoginEvent event,
    Emitter<FirebaseAuthState> emit,
  ) async {
    emit(FirebaseAuthLoading());

    try {
      final user = await repository.login(
        email: event.email,
        password: event.password,
      );

      if (user == null) {
        emit(FirebaseAuthFailure('Login failed'));
      } else {
        emit(FirebaseAuthSuccess(user));
      }
    } catch (error) {
      emit(FirebaseAuthFailure(error.toString()));
    }
  }

  Future<void> _onLogout(
    FirebaseLogoutEvent event,
    Emitter<FirebaseAuthState> emit,
  ) async {
    await repository.logout();

    emit(FirebaseAuthInitial());
  }
}