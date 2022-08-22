part of 'bookmark_screen_changer_cubit.dart';

abstract class BookmarkScreenChangerState {
  List<int> bookmarks;
  BookmarkScreenChangerState(this.bookmarks);
}

class BookmarkScreenChangerInitial extends BookmarkScreenChangerState {
  BookmarkScreenChangerInitial() : super([]);
}

class BookmarkScreenChangerUpdate extends BookmarkScreenChangerState {
  BookmarkScreenChangerUpdate(List<int> b) : super(b);
}
