part of 'state_cubit.dart';

abstract class StateState extends Equatable {
  final bool enabled;
  const StateState(this.enabled);

  @override
  List<Object> get props => [enabled];
}

class StateInitial extends StateState {
  const StateInitial() : super(false);
}

class StateCurrent extends StateState {
  const StateCurrent(bool e) : super(e);
}
