// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bible.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Verse _$VerseFromJson(dynamic json) => Verse(
      json as String,
    );

Map<String, dynamic> _$VerseToJson(Verse instance) => <String, dynamic>{
      'description': instance.description,
    };

Chapter _$ChapterFromJson(List<dynamic> json) => Chapter(
      json.map((e) => Verse.fromJson(e)).toList(),
      //(json['verses'] as List<dynamic>)
      //    .map((e) => Verse.fromJson(e as Map<String, dynamic>))
      //    .toList(),
    );

Map<String, dynamic> _$ChapterToJson(Chapter instance) => <String, dynamic>{
      'verses': instance.verses,
    };

Book _$BookFromJson(Map<String, dynamic> json) => Book(
      json['name'] as String,
      (json['chapters'] as List<dynamic>)
          .map((e) => Chapter.fromJson(e))
          .toList(),
    );

Map<String, dynamic> _$BookToJson(Book instance) => <String, dynamic>{
      'name': instance.name,
      'chapters': instance.chapters,
    };

Bible _$BibleFromJson(Map<String, dynamic> json) => Bible(
      (json['books'] as List<dynamic>)
          .map((e) => Book.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BibleToJson(Bible instance) => <String, dynamic>{
      'books': instance.books,
    };
