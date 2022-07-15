import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_starter_event.dart';
part 'app_starter_state.dart';

class AppStarterBloc extends Bloc<AppStarterEvent, AppStarterState> {
  AppStarterBloc() : super(const AppStarterState()) {
    on<AppStarterLoadingEvent>((event, emit) {
      emit(const AppStarterState(status: StarterStateStatus.loading));
    });
    on<AppStarterSuccessEvent>((event, emit) {
      emit(const AppStarterState(status: StarterStateStatus.success));
    });
    on<AppStarterFailureEvent>((event, emit) {
      emit(const AppStarterState(status: StarterStateStatus.failure));
    });
  }
}
