part of 'bible_page_changer_bloc.dart';

enum ChangePageState {
  none,
  initial,
  previousPage,
  nextPage,
  decrement,
  finalize,
  increment,
  exchangeStack
}

abstract class BiblePageChangerState extends Equatable {
  final ChangePageState pageState;
  final int pageIndex;
  final int maxSize;
  final int selectedVerse;

  const BiblePageChangerState(
      this.pageState, this.pageIndex, this.maxSize, this.selectedVerse);

  @override
  List<Object?> get props => [pageState, pageIndex, maxSize, selectedVerse];
}

class BibleChangePage extends BiblePageChangerState {
  const BibleChangePage(ChangePageState ps, int pi, int ms, int sv)
      : super(ps, pi, ms, sv);
}
