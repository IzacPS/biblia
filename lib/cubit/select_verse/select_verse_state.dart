part of 'select_verse_cubit.dart';

int idx = 0;

abstract class SelectVerseState extends Equatable {
  final int index;
  const SelectVerseState(this.index);

  @override
  List<Object> get props => [index];
}

class SelectVerseInitial extends SelectVerseState {
  SelectVerseInitial() : super(idx++);
}
