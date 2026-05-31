// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:test_app/blocs/todo/todo_bloc.dart';
// import 'package:test_app/blocs/todo/todo_event.dart';

// //import 'cubits/todo_cubit.dart';
// import 'screens/todo_home_page.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//         create: (context) => TodoBloc()..add(LoadTodosEvent()),
// // create: (context) => TodoCubit()..loadTodos(),
//       child: const MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'Todo App',
//         home: TodoHomePage(),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'screens/login_screen.dart';
// import 'screens/api_todo_screen.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Todo App',
//       home: LoginScreen(),
//      // home: ApiTodoScreen(),
//     );
//   }
// }


// import 'package:flutter/material.dart';

// import 'screens/counter_screen.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: CounterScreen(),
//     );
//   }
// }







// This screen can change, so we use StatefulWidget.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/auth_event.dart';
import 'repositories/auth_repository.dart';
import 'screens/auth_wrapper.dart';
import 'services/auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final authRepository = AuthRepository(authService);

    return BlocProvider(
      create: (context) =>
          AuthBloc(authRepository)..add(CheckAuthStatusEvent()),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todo App',
        home: AuthWrapper(),
      ),
    );
  }
}