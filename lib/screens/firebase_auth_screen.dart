import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/screens/firestore_todo_screen.dart';

import '../blocs/firebase_auth/firebase_auth_bloc.dart';
import '../blocs/firebase_auth/firebase_auth_event.dart';
import '../blocs/firebase_auth/firebase_auth_state.dart';
import '../repositories/firebase_auth_repository.dart';
import '../services/firebase_auth_service.dart';
import '../services/firestore_service.dart';

class FirebaseAuthScreen extends StatefulWidget {
  const FirebaseAuthScreen({super.key});

  @override
  State<FirebaseAuthScreen> createState() => _FirebaseAuthScreenState();
}

class _FirebaseAuthScreenState extends State<FirebaseAuthScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void signUp(BuildContext context) {
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    context.read<FirebaseAuthBloc>().add(
      FirebaseSignUpEvent(email: email, password: password),
    );
  }

  void login(BuildContext context) {
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    context.read<FirebaseAuthBloc>().add(
      FirebaseLoginEvent(email: email, password: password),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final authService = FirebaseAuthService();
        final firestoreService = FirestoreService();

        final repository = FirebaseAuthRepository(
          firebaseAuthService: authService,
          firestoreService: firestoreService,
        );

        return FirebaseAuthBloc(repository)
          ..add(FirebaseCheckAuthStatusEvent());
      },
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Firebase Auth'),
              centerTitle: true,
            ),
            body: BlocConsumer<FirebaseAuthBloc, FirebaseAuthState>(
              listener: (context, state) {
                if (state is FirebaseAuthSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Logged in: ${state.user.email}')),
                  );
                }

                if (state is FirebaseUserProfileLoaded) {
                  final email = state.profileData['email'];

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Profile loaded: $email'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }

                if (state is FirebaseAuthFailure) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                final bool isLoading = state is FirebaseAuthLoading;

                if (state is FirebaseAuthSuccess ||
                    state is FirebaseUserProfileLoaded) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Firebase Login Successful',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),

                        if (state is FirebaseAuthSuccess)
                          Text('Email: ${state.user.email}'),

                        if (state is FirebaseUserProfileLoaded)
                          Text('Email: ${state.profileData['email']}'),

                        const SizedBox(height: 20),

                        ElevatedButton(
                          onPressed: () {
                            context.read<FirebaseAuthBloc>().add(
                              FirebaseLoadUserProfileEvent(),
                            );
                          },
                          child: const Text('Load Profile'),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const FirestoreTodoScreen(),
                              ),
                            );
                          },
                          child: const Text('Go to Firestore Todos'),
                        ),
                        const SizedBox(height: 12),

                        ElevatedButton(
                          onPressed: () {
                            context.read<FirebaseAuthBloc>().add(
                              FirebaseLogoutEvent(),
                            );
                          },
                          child: const Text('Logout'),
                        ),
                      ],
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Firebase Auth Practice',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 24),

                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 16),

                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  signUp(context);
                                },
                          child: isLoading
                              ? const CircularProgressIndicator()
                              : const Text('Sign Up'),
                        ),
                      ),

                      const SizedBox(height: 12),

                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  login(context);
                                },
                          child: const Text('Login'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
