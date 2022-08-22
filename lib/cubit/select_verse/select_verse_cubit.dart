import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'select_verse_state.dart';

class SelectVerseCubit extends Cubit<SelectVerseState> {
  SelectVerseCubit() : super(SelectVerseInitial());

  update() {
    emit(SelectVerseInitial());
  }

  // selectIndex(int index) {
  //   emit(SelectVerseIndex(index));
  // }

  // unselectAll() {
  //   emit(SelectVerseInitial());
  // }

  // unselectIndex(int index){
  //   emit(UnselectVerseIndex(index));
  // }

  // getSelected() => state;
}
