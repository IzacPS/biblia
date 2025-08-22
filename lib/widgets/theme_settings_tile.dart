import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import '../cubit/theme_cubit.dart' as cubit;

class ThemeSettingsTile extends AbstractSettingsTile {
  const ThemeSettingsTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<cubit.ThemeCubit, cubit.ThemeMode>(
      builder: (context, themeMode) {
        return SettingsTile.navigation(
          title: Text("Tema", style: GoogleFonts.ptSans()),
          description: Text(
            context.read<cubit.ThemeCubit>().themeText,
            style: GoogleFonts.ptSans(),
          ),
          leading: Icon(
            themeMode == cubit.ThemeMode.dark
                ? Icons.dark_mode
                : themeMode == cubit.ThemeMode.light
                    ? Icons.light_mode
                    : Icons.brightness_auto,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: (context) {
            _showThemeDialog(context);
          },
        );
      },
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: context.read<cubit.ThemeCubit>(),
          child: AlertDialog(
            title: Text(
              "Selecionar Tema",
              style: GoogleFonts.ptSans(fontWeight: FontWeight.bold),
            ),
            content: BlocBuilder<cubit.ThemeCubit, cubit.ThemeMode>(
              builder: (context, currentTheme) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildThemeOption(
                      context,
                      "Claro",
                      Icons.light_mode,
                      cubit.ThemeMode.light,
                      currentTheme,
                    ),
                    _buildThemeOption(
                      context,
                      "Escuro",
                      Icons.dark_mode,
                      cubit.ThemeMode.dark,
                      currentTheme,
                    ),
                    _buildThemeOption(
                      context,
                      "Sistema",
                      Icons.brightness_auto,
                      cubit.ThemeMode.system,
                      currentTheme,
                    ),
                  ],
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(
                  "Cancelar",
                  style: GoogleFonts.ptSans(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    String title,
    IconData icon,
    cubit.ThemeMode themeMode,
    cubit.ThemeMode currentTheme,
  ) {
    final isSelected = themeMode == currentTheme;
    
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected 
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
      ),
      title: Text(
        title,
        style: GoogleFonts.ptSans(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected 
              ? Theme.of(context).colorScheme.primary
              : null,
        ),
      ),
      trailing: isSelected 
          ? Icon(
              Icons.check,
              color: Theme.of(context).colorScheme.primary,
            )
          : null,
      onTap: () {
        final themeCubit = context.read<cubit.ThemeCubit>();
        switch (themeMode) {
          case cubit.ThemeMode.light:
            themeCubit.setLightTheme();
            break;
          case cubit.ThemeMode.dark:
            themeCubit.setDarkTheme();
            break;
          case cubit.ThemeMode.system:
            themeCubit.setSystemTheme();
            break;
        }
        Navigator.pop(context);
      },
    );
  }
}