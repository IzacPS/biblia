import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sqflite/sqflite.dart';
import '../model/bible.dart';
import '../model/bible_page.dart';

class BibleRepository {
  BibleRepository(Database database) : _database = database;

  final Database _database;

  Bible? bible;
  List<BiblePageData>? pagesData = [];
  Future<(Bible? bible, List<BiblePageData>? pagesData)> loadBible({
    required double screenWidth,
    required double screenHeight,
    required double leftPadding,
    required double rightPadding,
    required double topPadding,
    required double bottomPadding,
    required double fontSize,
  }) async {
    if (bible != null && pagesData != null) return (bible, pagesData);
    await _readBibleFromFile();
    _configureBibleIndexes();
    _setBiblePagesData(
      screenWidth: screenWidth,
      screenHeight: screenHeight,
      leftPadding: leftPadding,
      rightPadding: rightPadding,
      topPadding: topPadding,
      bottomPadding: bottomPadding,
      fontSize: fontSize,
    );
    await _setBookmarksFromDatabase();

    return (bible, pagesData);
  }

  Future<void> _readBibleFromFile() async {
    bible = Bible.fromJson(
      jsonDecode(await rootBundle.loadString('assets/json/pt_acf.json')),
    );
  }

  void _configureBibleIndexes() {
    _setListIndex(bible!.books);
    for (var element in bible!.books) {
      _setListIndex(element.chapters);
      for (var element in element.chapters) {
        _setListIndex(element.verses);
      }
    }
  }

  void _setListIndex<T extends BaseId>(List<T> list) {
    for (int i = 0; i < list.length; i++) {
      list[i].id = i;
    }
  }

  void _setBiblePagesData({
    required double screenWidth,
    required double screenHeight,
    required double leftPadding,
    required double rightPadding,
    required double topPadding,
    required double bottomPadding,
    required double fontSize,
  }) {
    //the max height that the verses can ocupy
    double multiplier = 0;
    //the max size that the text can ocupy in one line
    final textWidth = screenWidth - (leftPadding + rightPadding);
    //this is the padding top and bottom configured for each verse
    final textHeight = topPadding + bottomPadding;

    for (int b = 0; b < bible!.books.length; b++) {
      for (int c = 0; c < bible!.books[b].chapters.length; c++) {
        int min = 0;
        int i;
        multiplier = 0;
        for (i = 0; i < bible!.books[b].chapters[c].verses.length; i++) {
          //calculate the number of lines based on the font size and padding left and right
          var lines =
              (bible!.books[b].chapters[c].verses[i].description.length
                      .toDouble() *
                  fontSize) /
              textWidth;

          multiplier += ((fontSize * lines) + textHeight);

          //if we hit the height limit for the verses, just add this a a page
          //then start search again for the next page
          if (multiplier >= screenHeight) {
            pagesData!.add(BiblePageData(b, c, min, i));
            min = i + 1;
            multiplier = 0;
          }
        }
        //check if here is text left, then add as another page
        i--;
        if ((i - min + 1) > 0) {
          pagesData!.add(BiblePageData(b, c, min, i));
        }
      }
    }
  }

  Future<int> getBibleDataIndex(BiblePageDataSearch? searchData) async {
    if (searchData == null) return -1;
    return pagesData!.indexWhere((element) {
      return element.book == searchData.book &&
          element.chapter == searchData.chapter &&
          (searchData.verse >= element.fromVerse &&
              searchData.verse <= element.toVerse);
    });
  }

  Future<void> _setBookmarksFromDatabase() async {
    await _database.rawQuery('SELECT * FROM bookmarks').then((value) {
      for (var element in value) {
        var index = element['pagedataindex'] as int;
        pagesData![index].bookmarked = true;
      }
    });
  }

  Future<List<Map<String, Object?>>> readBookmarks() async {
    return _database.rawQuery('SELECT * FROM bookmarks');
  }

  Future<int> saveBookmark(int bookmarkIndex) {
    return _database.insert('bookmarks', {'pagedataindex': bookmarkIndex});
  }

  Future<int> removeBookmark(int bookmarkIndex) {
    return _database.delete(
      'bookmarks',
      where: 'pagedataindex = ?',
      whereArgs: [bookmarkIndex],
    );
  }
}
