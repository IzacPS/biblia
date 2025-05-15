import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../repository/bible_repository.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getApplicationDocumentsDirectory()).path,
    ),
  );

  final database = await openDatabase(
    join(await getDatabasesPath(), 'biblia.db'),
    onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE IF NOT EXISTS saved (id INTEGER '
        'PRIMARY KEY AUTOINCREMENT, description TEXT, data TEXT)',
      );
      await db.execute(
        'CREATE TABLE IF NOT EXISTS bookmarks (id INTEGER '
        'PRIMARY KEY AUTOINCREMENT, pagedataindex INTEGER)',
      );
    },
    version: 1,
  );

  BibleRepository bibleRepository = BibleRepository(database);
  SharedPreferencesAsync sharedPreferences = SharedPreferencesAsync();
  final repositories = {
    BibleRepository: bibleRepository,
    SharedPreferencesAsync: sharedPreferences,
  };

  runApp(App(repositories: repositories));
}
