import 'package:biblia/bloc/bible_page_changer/bible_page_changer_bloc.dart';
import 'package:biblia/cubit/bookmark_screen_changer/bookmark_screen_changer_cubit.dart';
import 'package:biblia/cubit/read_progress/read_progress_cubit.dart';
import 'package:biblia/repo/bible_repo/bible_repo.dart';
import 'package:biblia/widget/bible_page/bible_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqflite/sqflite.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bible = context.read<BibleRepository>().bible;
    var pagesData = context.read<BibleRepository>().pagesData;
    context
        .read<Database?>()
        ?.rawQuery('SELECT * FROM bookmarks')
        .then((value) {
      var list = value.map((e) => e['pagedataindex'] as int).toList();
      context.read<BookmarkScreenChangerCubit>().update(list);
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marcações'),
      ),
      body:
          BlocConsumer<BookmarkScreenChangerCubit, BookmarkScreenChangerState>(
        listener: (context, state) {
          if (state is BookmarkScreenChangerInitial) {
            context
                .read<Database?>()
                ?.rawQuery('SELECT * FROM bookmarks')
                .then((value) {
              var list = value.map((e) => e['pagedataindex'] as int).toList();
              context.read<BookmarkScreenChangerCubit>().update(list);
            });
          }
        },
        builder: (context, state) {
          return ListView.builder(
            itemCount: state.bookmarks.length,
            itemBuilder: (context, index) {
              var data = pagesData[state.bookmarks[index]];
              return ListTile(
                leading: const Icon(
                  Icons.bookmark_added_outlined,
                  color: Colors.black,
                ),
                title: Text(
                  '${bible.books[data.book].name}  ${data.chapter + 1}:${data.fromVerse + 1}-${data.toVerse + 1}',
                  style: GoogleFonts.ptSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  context.read<BiblePageChangerBloc>().add(
                      BibleChangePageInitialEvent(state.bookmarks[index], -1));
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const BiblePage()));
                },
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    pagesData[state.bookmarks[index]].bookmarked = false;
                    context.read<Database?>()?.delete('bookmarks',
                        where: 'pagedataindex = ?',
                        whereArgs: [
                          state.bookmarks[index]
                        ]).then((value) =>
                        {context.read<BookmarkScreenChangerCubit>().load()});
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
