import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'android_root.dart';
import 'cubit/theme_cubit.dart' as cubit;
import 'theme/app_theme.dart';

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return BlocProvider(
        create: (context) => cubit.ThemeCubit(),
        child: BlocBuilder<cubit.ThemeCubit, cubit.ThemeMode>(
          builder: (context, themeMode) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: "Bíblia",
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: _getFlutterThemeMode(themeMode),
              home: AndroidRoot(),
            );
          },
        ),
      );
    } else {
      return CupertinoApp();
    }
  }

  ThemeMode _getFlutterThemeMode(cubit.ThemeMode themeMode) {
    switch (themeMode) {
      case cubit.ThemeMode.light:
        return ThemeMode.light;
      case cubit.ThemeMode.dark:
        return ThemeMode.dark;
      case cubit.ThemeMode.system:
        return ThemeMode.system;
    }
  }
}
