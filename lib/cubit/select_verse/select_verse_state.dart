part of 'select_verse_cubit.dart';

abstract class SelectVerseState extends Equatable {
  final int index;
  const SelectVerseState(this.index);

  @override
  List<Object> get props => [index];
}

class SelectVerseInitial extends SelectVerseState {
  const SelectVerseInitial() : super(-1);
}

class SelectVerseIndex extends SelectVerseState {
  const SelectVerseIndex(int i) : super(i);
}
