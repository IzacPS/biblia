import 'package:json_annotation/json_annotation.dart';

part 'bible.g.dart';

class BaseId {
  @JsonKey(includeFromJson: false, includeToJson: false)
  late int id;
}

@JsonSerializable()
class Verse extends BaseId {
  final String description;

  Verse(this.description);

  factory Verse.fromJson(dynamic json) => _$VerseFromJson(json);

  Map<String, dynamic> toJson() => _$VerseToJson(this);
}

@JsonSerializable()
class Chapter extends BaseId {
  List<Verse> verses;
  Chapter(this.verses);

  factory Chapter.fromJson(List<dynamic> json) => _$ChapterFromJson(json);

  Map<String, dynamic> toJson() => _$ChapterToJson(this);
}

@JsonSerializable()
class Book extends BaseId {
  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'chapters')
  List<Chapter> chapters;
  Book(this.name, this.chapters);

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);

  Map<String, dynamic> toJson() => _$BookToJson(this);
}

@JsonSerializable()
class Bible {
  @JsonKey(name: 'books')
  List<Book> books;
  Bible(this.books);

  factory Bible.fromJson(Map<String, dynamic> json) => _$BibleFromJson(json);

  Map<String, dynamic> toJson() => _$BibleToJson(this);
}
