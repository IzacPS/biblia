import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

enum ThemeMode {
  light,
  dark,
  system,
}

class ThemeCubit extends HydratedCubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  void setLightTheme() => emit(ThemeMode.light);
  void setDarkTheme() => emit(ThemeMode.dark);
  void setSystemTheme() => emit(ThemeMode.system);

  void toggleTheme() {
    switch (state) {
      case ThemeMode.light:
        emit(ThemeMode.dark);
        break;
      case ThemeMode.dark:
        emit(ThemeMode.light);
        break;
      case ThemeMode.system:
        emit(ThemeMode.light);
        break;
    }
  }

  bool get isDarkMode {
    if (state == ThemeMode.system) {
      // Aqui você pode verificar o tema do sistema
      return WidgetsBinding.instance.platformDispatcher.platformBrightness == 
             Brightness.dark;
    }
    return state == ThemeMode.dark;
  }

  String get themeText {
    switch (state) {
      case ThemeMode.light:
        return 'Claro';
      case ThemeMode.dark:
        return 'Escuro';
      case ThemeMode.system:
        return 'Sistema';
    }
  }

  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    try {
      final themeIndex = json['theme'] as int?;
      if (themeIndex != null && themeIndex < ThemeMode.values.length) {
        return ThemeMode.values[themeIndex];
      }
    } catch (e) {
      // Se houver erro, retorna o tema padrão
    }
    return ThemeMode.system;
  }

  @override
  Map<String, dynamic>? toJson(ThemeMode state) {
    return {'theme': state.index};
  }
}