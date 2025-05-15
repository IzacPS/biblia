import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repository/bible_repository.dart';
import "root.dart";

class App extends StatelessWidget {
  const App({super.key, Map<Type, Object> repositories = const {}})
    : _repositories = repositories;

  final Map<Type, Object> _repositories;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<BibleRepository>.value(
          value: _repositories[BibleRepository] as BibleRepository,
        ),
        RepositoryProvider<SharedPreferencesAsync>.value(
          value:
              _repositories[SharedPreferencesAsync] as SharedPreferencesAsync,
        ),
      ],
      child: Root(),
    );
  }
}
