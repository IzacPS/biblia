import 'dart:async';

import 'package:biblia/notifier/appbar_title_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/bible.dart';
import '../model/bible_page.dart';
import '../page/bible_page.dart';
import '../repository/bible_repository.dart';
import '../screen/hero_dialog_route.dart';
import '../screen/popup_card.dart';

class BibleScreen extends StatefulWidget {
  const BibleScreen({
    super.key,
    required ValueNotifier<double> progressNotifier,
  }) : _progressNotifier = progressNotifier;

  final ValueNotifier<double> _progressNotifier;

  @override
  State<BibleScreen> createState() => _BiblePageState();
}

class _BiblePageState extends State<BibleScreen> {
  final ForceValueNotifier<String> _appBarNotifier = ForceValueNotifier(
    "Carregando",
  );
  final ValueNotifier<int> _bookmarkNotifier = ValueNotifier(0);
  final ValueNotifier<int> _currentPage = ValueNotifier(-1);

  Future<(Bible?, List<BiblePageData>?, int)> _loadBible() async {
    final preferences = context.read<SharedPreferencesAsync>();
    final repository = context.read<BibleRepository>();

    final value = (repository.bible, repository.pagesData);
    final index = await preferences.getInt("index") ?? 0;

    // final children =
    //     value.$2!
    //         .map(
    //           (data) => BiblePage(
    //             appBarNotifier: _appBarNotifier,
    //             bible: value.$1!,
    //             pageData: data,
    //           ),
    //         )
    //         .toList();
    return (value.$1, value.$2, index);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // _appBarNotifier.dispose();
    // _bookmarkNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // AdHelper.loadPageBanner();
    return FutureBuilder(
      future: _loadBible(),
      builder: (_, snapshot) {
        if (snapshot.connectionState != ConnectionState.done ||
            snapshot.data == null) {
          return Container(
            color: Colors.white,
            child: Center(child: RefreshProgressIndicator()),
          );
        }
        final value = snapshot.data!;
        _bookmarkNotifier.value = value.$3;
        _currentPage.value = value.$3;
        return Scaffold(
          appBar: AppBar(
            title: ValueListenableBuilder<String>(
              valueListenable: _appBarNotifier,
              builder: (context, title, _) {
                return Text(title, style: GoogleFonts.ptSans());
              },
            ),
            actions: [
              ValueListenableBuilder(
                valueListenable: _bookmarkNotifier,
                builder: (_, idx, __) {
                  return _BibleBookmark(data: value.$2!, index: idx);
                },
              ),
              _BibleSearch(
                bible: value.$1!,
                onSearchResult: (newIndex) {
                  final preferences = context.read<SharedPreferencesAsync>();
                  preferences.setInt("index", newIndex);
                  double progress = newIndex / value.$2!.length;
                  preferences.setDouble("progress", progress);
                  widget._progressNotifier.value = progress;
                  _bookmarkNotifier.value = newIndex;
                  _currentPage.value = newIndex;
                  debugPrint("pageIndex ${_currentPage.value}");
                },
              ),
            ],
          ),
          body: SafeArea(
            child: ValueListenableBuilder(
              valueListenable: _currentPage,
              builder:
                  (_, pageIndex, child) =>
                      (pageIndex != -1)
                          ? BiblePage(
                            appBarNotifier: _appBarNotifier,
                            bible: value.$1!,
                            pageData: value.$2![pageIndex],
                          )
                          : Center(child: CircularProgressIndicator()),
            ),
          ),
          bottomNavigationBar: SizedBox(
            height: 54,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      if (_currentPage.value > 0) {
                        _currentPage.value = _currentPage.value - 1;
                        final preferences =
                            context.read<SharedPreferencesAsync>();
                        preferences.setInt("index", _currentPage.value);
                        double progress = _currentPage.value / value.$2!.length;
                        preferences.setDouble("progress", progress);
                        widget._progressNotifier.value = progress;
                        _bookmarkNotifier.value = _currentPage.value;
                      }
                    },
                    icon: Icon(Icons.keyboard_arrow_left_rounded),
                  ),
                  IconButton(
                    onPressed: () {
                      if (_currentPage.value < value.$2!.length) {
                        _currentPage.value = _currentPage.value + 1;
                        final preferences =
                            context.read<SharedPreferencesAsync>();
                        preferences.setInt("index", _currentPage.value);
                        double progress = _currentPage.value / value.$2!.length;
                        preferences.setDouble("progress", progress);
                        widget._progressNotifier.value = progress;
                        _bookmarkNotifier.value = _currentPage.value;
                      }
                    },
                    icon: Icon(Icons.keyboard_arrow_right_rounded),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BibleBookmark extends StatefulWidget {
  const _BibleBookmark({required this.data, required this.index});
  final List<BiblePageData> data;
  final int index;
  @override
  State<_BibleBookmark> createState() => __BibleBookmarkState();
}

class __BibleBookmarkState extends State<_BibleBookmark> {
  @override
  Widget build(BuildContext context) {
    final index = widget.index;
    final data = widget.data[index];
    final bibleRepository = context.read<BibleRepository>();
    return Hero(
      tag: 'bible-page-bookmark-hero',
      child: Material(
        color: Colors.brown,
        child: IconButton(
          color: (data.bookmarked) ? Colors.yellow : Colors.white,
          onPressed: () {
            setState(() {
              data.bookmarked = !data.bookmarked;
            });
            if (data.bookmarked) {
              bibleRepository.saveBookmark(index);
            } else {
              bibleRepository.removeBookmark(index);
            }
          },
          icon:
              (data.bookmarked)
                  ? const Icon(Icons.bookmark_added)
                  : const Icon(Icons.bookmark_add),
        ),
      ),
    );
  }
}

class _BibleSearch extends StatefulWidget {
  const _BibleSearch({required this.bible, required this.onSearchResult});

  final Bible bible;
  final void Function(int index) onSearchResult;

  @override
  State<_BibleSearch> createState() => __BibleSearchState();
}

class __BibleSearchState extends State<_BibleSearch> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'add-todo-hero',
      child: Material(
        color: Colors.brown,
        child: IconButton(
          onPressed: () {
            Navigator.of(context)
                .push<BiblePageDataSearch>(
                  HeroDialogRoute(
                    builder: (context) {
                      return PopupCard(bible: widget.bible);
                    },
                  ),
                )
                .then((pageDataSearch) async {
                  if (pageDataSearch == null) return;
                  if (!context.mounted) return;
                  final bibleRepository = context.read<BibleRepository>();

                  final index = await bibleRepository.getBibleDataIndex(
                    pageDataSearch,
                  );
                  widget.onSearchResult(index);
                });
          },
          icon: const Icon(Icons.search, color: Colors.white),
        ),
      ),
    );
  }
}
