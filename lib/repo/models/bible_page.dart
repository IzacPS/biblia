class BiblePageDataSearch {
  late int book;
  late int chapter;
  late int verse;

  BiblePageDataSearch(this.book, this.chapter, this.verse);

  @override
  String toString() {
    return 'BiblePageData($book,$chapter,$verse)';
  }
}

class BiblePageData {
  late int book;
  late int chapter;
  late int fromVerse;
  late int toVerse;

  BiblePageData(this.book, this.chapter, this.fromVerse, this.toVerse);

  @override
  String toString() {
    return 'BiblePageData($book,$chapter,$fromVerse,$toVerse)';
  }
}
