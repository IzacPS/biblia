import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/theme_settings_tile.dart';

class ConfigurationScreen extends StatelessWidget {
  const ConfigurationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Configurações", style: GoogleFonts.ptSans())),
      body: SafeArea(
        child: SettingsList(
          sections: [
            // SettingsSection(tiles: []),
            SettingsSection(
              title: Text("Aparência", style: GoogleFonts.ptSans()),
              tiles: [
                const ThemeSettingsTile(),
                SettingsTile.navigation(
                  title: Text("Tamanho da fonte", style: GoogleFonts.ptSans()),
                  description: Text("Médio", style: GoogleFonts.ptSans()),
                  leading: Icon(
                    Icons.text_fields,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: (context) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Ainda não implementado",
                          style: GoogleFonts.ptSans(),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            SettingsSection(
              title: Text("Informações", style: GoogleFonts.ptSans()),
              tiles: [
                SettingsTile.navigation(
                  title: Text("Sobre o app", style: GoogleFonts.ptSans()),
                  leading: Icon(
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: (context) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            "Sobre o App",
                            style: GoogleFonts.ptSans(),
                          ),
                          content: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Esta aplicação utiliza o texto da Bíblia Sagrada – Versão Almeida Corrigida Fiel (ACF).\n",
                                  style: GoogleFonts.ptSans(),
                                ),
                                Text(
                                  "Fonte: Sociedade Bíblica Trinitariana do Brasil (SBTB)\nwww.sbtb.com.br\n",
                                  style: GoogleFonts.ptSans(),
                                ),
                                Text(
                                  "O conteúdo bíblico é utilizado de forma íntegra, sem alterações, conforme permitido pela SBTB.\n",
                                  style: GoogleFonts.ptSans(),
                                ),
                                Text(
                                  "Este aplicativo é independente e não possui vínculo com a SBTB.",
                                  style: GoogleFonts.ptSans(),
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                "Fechar",
                                style: GoogleFonts.ptSans(),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
