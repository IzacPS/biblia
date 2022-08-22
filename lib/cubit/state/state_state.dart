part of 'state_cubit.dart';

abstract class StateState extends Equatable {
  final bool enabled;
  final Map<int, String>  selected;
  const StateState(this.enabled, this.selected);

  @override
  List<Object> get props => [enabled, selected];
}

class StateInitial extends StateState {
  StateInitial() : super(false, {});
}

class StateCurrent extends StateState {
  const StateCurrent(bool e, Map<int, String>  s) : super(e, s);
}
