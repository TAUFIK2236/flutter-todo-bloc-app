// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:test_app/counter_cubit.dart';



// // class CounterScreen extends StatelessWidget {
// //   const CounterScreen({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return BlocProvider(
// //       create: (context) => CounterCubit(),
// //       child: Scaffold(
// //         appBar: AppBar(
// //           title: const Text('Cubit Counter'),
// //           centerTitle: true,
// //         ),
// //         body: Center(
// //           child: BlocBuilder<CounterCubit, int>(
// //             builder: (context, count) {
// //               return Text(
// //                 '$count',
// //                 style: const TextStyle(
// //                   fontSize: 60,
// //                   fontWeight: FontWeight.bold,
// //                 ),
// //               );
// //             },
// //           ),
// //         ),
// //         floatingActionButton: Row(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             FloatingActionButton(
// //               onPressed: () {
// //                 context.read<CounterCubit>().decrement();
// //               },
// //               child: const Icon(Icons.remove),
// //             ),
// //             const SizedBox(width: 12),
// //             FloatingActionButton(
// //               onPressed: () {
// //                 context.read<CounterCubit>().increment();
// //               },
// //               child: const Icon(Icons.add),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:test_app/counter_cubit.dart';

// class CounterScreen extends StatelessWidget {
//   const CounterScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => CounterCubit(),
//       child: Builder(
//         builder: (context) {
//           return Scaffold(
//             appBar: AppBar(
//               title: const Text('Cubit Counter'),
//               centerTitle: true,
//             ),
//             body: Center(
//               child: BlocBuilder<CounterCubit, int>(
//                 builder: (context, count) {
//                   return Text(
//                     '$count',
//                     style: const TextStyle(
//                       fontSize: 60,
//                       fontWeight: FontWeight.bold,
//                     ), 
//                   );
//                 },
//               ),
//             ),
//             floatingActionButton: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 FloatingActionButton(
//                   onPressed: () {
//                     context.read<CounterCubit>().decrement();
//                   },
//                   child: const Icon(Icons.remove),
//                 ),
//                 const SizedBox(width: 12),
//                 FloatingActionButton(
//                   onPressed: () {
//                     context.read<CounterCubit>().increment();
//                   },
//                   child: const Icon(Icons.add),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/counter_bloc.dart';

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('BLoC Counter'),
              centerTitle: true,
            ),
            body: Center(
              child: BlocBuilder<CounterBloc, int>(
                builder: (context, count) {
                  return Text(
                    '$count',
                    style: const TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
            floatingActionButton: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    context.read<CounterBloc>().add(DecrementEvent());
                  },
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 12),
                FloatingActionButton(
                  onPressed: () {
                    context.read<CounterBloc>().add(IncrementEvent());
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}