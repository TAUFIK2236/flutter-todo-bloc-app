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
