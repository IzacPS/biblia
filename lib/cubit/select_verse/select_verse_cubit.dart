import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'select_verse_state.dart';

class SelectVerseCubit extends Cubit<SelectVerseState> {
  SelectVerseCubit() : super(const SelectVerseInitial());

  selectIndex(int index) {
    emit(SelectVerseIndex(index));
  }

  unselect() {
    emit(const SelectVerseInitial());
  }
}
