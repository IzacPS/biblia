import 'package:flutter_bloc/flutter_bloc.dart';

part 'bookmark_state_state.dart';

class BookmarkStateCubit extends Cubit<BookmarkStateState> {
  BookmarkStateCubit() : super(BookmarkStateInitial());

  // setState(bool state){
  //   emit(BookmarkStateCurrent(state));
  // }

  update(){
    emit(BookmarkStateInitial());
  }
}

