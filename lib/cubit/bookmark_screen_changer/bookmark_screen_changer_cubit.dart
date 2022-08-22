import 'package:flutter_bloc/flutter_bloc.dart';

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
