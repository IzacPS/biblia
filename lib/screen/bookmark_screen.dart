import 'package:biblia/screen/bible_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repository/bible_repository.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({
    super.key,

    required ValueNotifier<double> progressNotifier,
  }) : _progressNotifier = progressNotifier;

  final ValueNotifier<double> _progressNotifier;

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  Future<List<int>> _loadBookmarks() async {
    // final bible = context.read<BibleRepository>().bible;
    final bibleRepository = context.read<BibleRepository>();
    final rawBookmarks = await bibleRepository.readBookmarks();

    var bookmarks = rawBookmarks.map((e) => e['pagedataindex'] as int).toList();
    return bookmarks;
  }

  @override
  Widget build(BuildContext context) {
    final bibleRepository = context.read<BibleRepository>();
    final bible = bibleRepository.bible!;
    final pagesData = bibleRepository.pagesData!;
    return Scaffold(
      appBar: AppBar(title: Text("Marcações", style: GoogleFonts.ptSans())),
      body: FutureBuilder(
        future: _loadBookmarks(),
        builder: (_, snapshot) {
          if (snapshot.connectionState != ConnectionState.done ||
              snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          }
          final bookmarks = snapshot.data!;
          if (bookmarks.isEmpty) {
            return Center(
              child: Text(
                "Você ainda não possui marcações.",
                style: GoogleFonts.ptSans(),
              ),
            );
          }
          return ListView.separated(
            separatorBuilder: (context, index) {
              return const Divider();
            },
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              var data = pagesData[bookmarks[index]];
              return ListTile(
                leading: const Icon(Icons.bookmark_added, color: Colors.black),
                title: Text(
                  '${bible.books[data.book].name}  ${data.chapter + 1}:${data.fromVerse + 1}-${data.toVerse + 1}',
                  style: GoogleFonts.ptSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  final preferences = context.read<SharedPreferencesAsync>();
                  preferences.setInt("index", bookmarks[index]);
                  double progress = bookmarks[index] / pagesData.length;
                  preferences.setDouble("progress", progress);
                  widget._progressNotifier.value = progress;

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => BibleScreen(
                            progressNotifier: widget._progressNotifier,
                          ),
                    ),
                  );
                },
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    pagesData[bookmarks[index]].bookmarked = false;
                    bibleRepository.removeBookmark(bookmarks[index]);
                    setState(() {
                      bookmarks.removeAt(index);
                    });
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
