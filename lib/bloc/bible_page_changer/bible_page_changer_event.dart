part of 'bible_page_changer_bloc.dart';

@immutable
abstract class BiblePageChangerEvent extends Equatable {
  //final int currentPage;
  //final int nextPage;

  const BiblePageChangerEvent();

  @override
  List<Object?> get props => [];
}

class BibleChangePageInitialEvent extends BiblePageChangerEvent {
  final int index;
  final int selectedVerseIndex;
  const BibleChangePageInitialEvent(this.index, this.selectedVerseIndex);

  @override
  List<Object?> get props => [index, selectedVerseIndex];
}

class BibleChangePageNextEvent extends BiblePageChangerEvent {
  const BibleChangePageNextEvent();
}

class BibleChangePagePrevEvent extends BiblePageChangerEvent {
  const BibleChangePagePrevEvent();
}

class BibleChangePageDecrementEvent extends BiblePageChangerEvent {
  const BibleChangePageDecrementEvent();
}

// class BibleChangePageDecrementPrepareEvent extends BiblePageChangerEvent {
//   const BibleChangePageDecrementPrepareEvent();
// }

class BibleChangePageFinalizeEvent extends BiblePageChangerEvent {
  const BibleChangePageFinalizeEvent();
}

class BibleChangePageIncrementEvent extends BiblePageChangerEvent {
  const BibleChangePageIncrementEvent();
}

class BibleChangePageExchangeStackEvent extends BiblePageChangerEvent {
  const BibleChangePageExchangeStackEvent();
}
