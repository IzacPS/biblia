import 'package:biblia/globals.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'state_state.dart';

class FabStateCubit extends Cubit<StateState> {
  FabStateCubit() : super(StateInitial());

  void setState(bool enabled, Map<int, String>  selected) {
    emit(StateCurrent(enabled, selected));
  }
}
