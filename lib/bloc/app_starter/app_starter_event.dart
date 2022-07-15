part of 'app_starter_bloc.dart';

abstract class AppStarterEvent extends Equatable {
  const AppStarterEvent();

  @override
  List<Object> get props => [];
}

class AppStarterLoadingEvent extends AppStarterEvent {}

class AppStarterSuccessEvent extends AppStarterEvent {}

class AppStarterFailureEvent extends AppStarterEvent {}
