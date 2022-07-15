import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'bible_page_changer_event.dart';
part 'bible_page_changer_state.dart';

class BiblePageChangerBloc
    extends HydratedBloc<BiblePageChangerEvent, BiblePageChangerState> {
  int maxSize;

  BiblePageChangerBloc(this.maxSize)
      : super(BibleChangePage(ChangePageState.none, 0, maxSize, -1)) {
    on<BibleChangePageInitialEvent>((event, emit) {
      emit(BibleChangePage(ChangePageState.initial, event.index, maxSize,
          event.selectedVerseIndex));
    });
    on<BibleChangePageNextEvent>((event, emit) {
      emit(BibleChangePage(
          ChangePageState.nextPage, state.pageIndex, maxSize, -1));
    });

    on<BibleChangePagePrevEvent>((event, emit) {
      emit(BibleChangePage(
          ChangePageState.previousPage, state.pageIndex, maxSize, -1));
    });

    on<BibleChangePageDecrementEvent>((event, emit) {
      emit(BibleChangePage(ChangePageState.decrement,
          (state.pageIndex - 1).clamp(0, maxSize), maxSize, -1));
    });

    // on<BibleChangePageFinalizeEvent>((event, emit) {
    //   emit(BibleChangePage(ChangePageState.finalize, state.pageIndex, maxSize));
    // });

    on<BibleChangePageIncrementEvent>((event, emit) {
      emit(BibleChangePage(ChangePageState.increment,
          (state.pageIndex + 1).clamp(0, maxSize), maxSize, -1));
    });

    // on<BibleChangePageExchangeStackEvent>((event, emit) {
    //   emit(BibleChangePage(
    //       ChangePageState.exchangeStack, state.pageIndex, maxSize));
    // });
  }

  @override
  BiblePageChangerState? fromJson(Map<String, dynamic> json) {
    return BibleChangePage(
        ChangePageState.none, json['pageIndex'] as int, maxSize, -1);
  }

  @override
  Map<String, dynamic>? toJson(BiblePageChangerState state) =>
      <String, dynamic>{'pageIndex': state.pageIndex};
}
