part of 'app_starter_bloc.dart';

enum StarterStateStatus { initial, loading, success, update, failure }

class AppStarterState extends Equatable {
  final StarterStateStatus status;
  const AppStarterState({this.status = StarterStateStatus.initial});

  @override
  List<Object> get props => [status];
}
