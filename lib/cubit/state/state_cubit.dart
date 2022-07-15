import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'state_state.dart';

class FabStateCubit extends Cubit<StateState> {
  FabStateCubit() : super(const StateInitial());

  void setState(bool enabled) {
    emit(StateCurrent(enabled));
  }
}
