import 'dart:convert';

import 'package:biblia/repo/models/bible/bible.dart';
import 'package:biblia/repo/models/bible_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show rootBundle;

class BibleRepository {
  late Bible bible;
  final List<BiblePageData> pagesData = [];
  late double screenWidth;
  late double screenHeight;

  BibleRepository();

  void setScreenSize(double width, double height) {
    screenWidth = width;
    screenHeight = height;
  }

  Future<void> loadBible() async {
    await _readBibleFromFile();
    _configureBibleIndexes();
    getBiblePages();
  }

  //TODO: load by language
  Future<void> _readBibleFromFile() async {
    bible = Bible.fromJson(
        jsonDecode(await rootBundle.loadString('assets/json/pt_nvi.json')));
  }

  void _configureBibleIndexes() {
    _setListIndex(bible.books);
    for (var element in bible.books) {
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

//TODO: configure with font size
  void getBiblePages() {
    double multiplier = 0;
    var textSize = screenWidth - 32;

    for (int b = 0; b < bible.books.length; b++) {
      for (int c = 0; c < bible.books[b].chapters.length; c++) {
        int min = 0;
        int i;
        multiplier = 0;
        for (i = 0; i < bible.books[b].chapters[c].verses.length; i++) {
          //size of the Text on screen without padding
          //32 of padding... 16 on each size of the Text
          //number of lines that a text ocupy
          var lines = (bible.books[b].chapters[c].verses[i].description.length
                      .toDouble() *
                  18) /
              textSize; // /
          //textSize;
          multiplier += (18 * lines);
          //min = multiplier.toInt();
          if (multiplier >= screenHeight) {
            pagesData.add(BiblePageData(b, c, min, i));
            min = i + 1;
            multiplier = 0;
          }
        }
        i--;
        if ((i - min + 1) > 0) {
          pagesData.add(BiblePageData(b, c, min, i));
        }
      }
    }
  }

  Future<int> getBibleDataIndex(BiblePageDataSearch? searchData) async {
    if (searchData == null) return -1;
    return pagesData.indexWhere((element) {
      return element.book == searchData.book &&
          element.chapter == searchData.chapter &&
          (searchData.verse >= element.fromVerse &&
              searchData.verse <= element.toVerse);
    });
  }

  void print() {
    debugPrint('pagesDataSize : ${pagesData.length}');
    for (int i = 0; i < 100; i++) {
      debugPrint(pagesData[i].toString());
    }
  }
}
