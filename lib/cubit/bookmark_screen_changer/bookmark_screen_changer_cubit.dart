import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'bookmark_screen_changer_state.dart';

class BookmarkScreenChangerCubit extends Cubit<BookmarkScreenChangerState> {
  BookmarkScreenChangerCubit() : super(BookmarkScreenChangerInitial());

  update(List<int> b) {
    emit(BookmarkScreenChangerUpdate(b));
  }

  load() {
    emit(BookmarkScreenChangerInitial());
  }
}
