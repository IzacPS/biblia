import 'package:biblia/notifier/appbar_title_notifier.dart';
import 'package:biblia/screen/bible_page_view_details.dart';
import 'package:flutter/material.dart';
import '../model/bible_page.dart';
import '../model/bible.dart';

class BiblePage extends StatefulWidget {
  const BiblePage({
    super.key,
    required ForceValueNotifier<String> appBarNotifier,
    required Bible bible,
    required BiblePageData pageData,
  }) : _appBarNotifier = appBarNotifier,
       _bible = bible,
       _pageData = pageData;

  final BiblePageData _pageData;
  final Bible _bible;
  final ForceValueNotifier<String> _appBarNotifier;

  @override
  State<BiblePage> createState() => _BiblePageState();
}

class _BiblePageState extends State<BiblePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final value =
        '${widget._bible.books[widget._pageData.book].name} ${widget._pageData.chapter + 1}:${widget._pageData.fromVerse + 1}-${widget._pageData.toVerse + 1}';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget._appBarNotifier.forceSet(value);
    });
    return BiblePageViewDetails(
      bible: widget._bible,
      pagesData: widget._pageData,
    );
  }
}
