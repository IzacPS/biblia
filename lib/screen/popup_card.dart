import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../model/bible.dart';
import '../model/bible_page.dart';

const String _heroAddTodo = 'add-todo-hero';

class PopupCard extends StatefulWidget {
  const PopupCard({super.key, required Bible bible}) : _bible = bible;

  final Bible _bible;

  @override
  State<PopupCard> createState() => _PopupCardState();
}

class _PopupCardState extends State<PopupCard> {
  int book = 0;
  int chapter = 0;
  int verse = 0;
  late Bible _bible;

  @override
  void initState() {
    super.initState();
    _bible = widget._bible;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: _heroAddTodo,
          // createRectTween: (begin, end) {
          //   return CustomRectTween(begin: begin, end: end);
          // },
          child: Material(
            type: MaterialType.card,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 8),
                      child: Text(
                        'Livro',
                        style: GoogleFonts.ptSans(fontSize: 18),
                      ),
                    ),
                    DropdownButtonFormField<Book>(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            width: 1,
                            //color: Colors.purple,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            width: 3,
                            //color: Colors.purple,
                          ),
                        ),
                      ),
                      value: _bible.books[book],
                      items:
                          _bible.books
                              .map(
                                (e) => DropdownMenuItem<Book>(
                                  value: e,
                                  child: Text(
                                    e.name,
                                    style: GoogleFonts.ptSans(),
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            book = value.id;
                            chapter = 0;
                            verse = 0;
                          });
                        }
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 8),
                      child: Text(
                        'Capítulo',
                        style: GoogleFonts.ptSans(fontSize: 18),
                      ),
                    ),

                    DropdownButtonFormField<Chapter>(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            width: 1,
                            //color: Colors.purple,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            width: 3,
                            //color: Colors.purple,
                          ),
                        ),
                      ),
                      value: _bible.books[book].chapters[chapter],
                      items:
                          _bible.books[book].chapters
                              .map(
                                (e) => DropdownMenuItem<Chapter>(
                                  value: e,
                                  child: Text(
                                    (book == 18)
                                        ? 'Salmo ${e.id + 1}'
                                        : 'Capítulo ${(e.id + 1).toString()}',
                                    style: GoogleFonts.ptSans(),
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            chapter = value.id;
                            verse = 0;
                          });
                        }
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 8),
                      child: Text(
                        'Versículo',
                        style: GoogleFonts.ptSans(fontSize: 18),
                      ),
                    ),

                    DropdownButtonFormField<Verse>(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            width: 1,
                            //color: Colors.purple,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            width: 3,
                            //color: Colors.purple,
                          ),
                        ),
                      ),
                      value: _bible.books[book].chapters[chapter].verses[verse],
                      items:
                          _bible.books[book].chapters[chapter].verses
                              .map(
                                (e) => DropdownMenuItem<Verse>(
                                  value: e,
                                  child: Text(
                                    '${(book == 18) ? 'Verso' : 'Versículo'} ${(e.id + 1).toString()}',
                                    style: GoogleFonts.ptSans(),
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            verse = value.id;
                          });
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 4),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop<BiblePageDataSearch>(
                            context,
                            BiblePageDataSearch(book, chapter, verse),
                          );
                        },
                        child: Text('Search', style: GoogleFonts.ptSans()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
