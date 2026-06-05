import 'package:flutter_bloc/flutter_bloc.dart';

// Parent event class
abstract class CounterEvent {}

// Child event classes
class IncrementEvent extends CounterEvent {}

class DecrementEvent extends CounterEvent {}

// Bloc
class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<IncrementEvent>((event, emit) {
      emit(state + 1);
    });

    on<DecrementEvent>((event, emit) {
      emit(state - 1);
    });
  }
}
