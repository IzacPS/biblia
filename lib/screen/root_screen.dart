import 'dart:async';

import 'package:biblia/screen/bookmark_screen.dart';
import 'package:biblia/screen/configuration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repository/bible_repository.dart';
import '../screen/bible_screen.dart';
import '../widgets/skeleton_loader.dart';
import '../widgets/simple_progress_bar.dart';
import '../theme/app_theme.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  final ValueNotifier<double> _progressNotifier = ValueNotifier(0.0);

  Future<void> _loadBible() async {
    final repository = context.read<BibleRepository>();

    final mediaQuery = MediaQuery.of(context);

    final screenWidth = mediaQuery.size.width;
    final totalHeight = mediaQuery.size.height;
    final statusBarHeight = mediaQuery.padding.top;
    final bottomPadding = mediaQuery.padding.bottom;
    final appBarHeight = kToolbarHeight;

    final screenHeight =
        totalHeight - statusBarHeight - appBarHeight - bottomPadding;
    await repository.loadBible(
      screenWidth: screenWidth,
      screenHeight: screenHeight,
      leftPadding: 16,
      rightPadding: 16,
      topPadding: 4,
      bottomPadding: 4,
      fontSize: 18,
    );
  }

  @override
  void initState() {
    super.initState();
    final preferences = context.read<SharedPreferencesAsync>();
    unawaited(
      preferences.getDouble("progress").then((value) {
        if (value != null) {
          _progressNotifier.value = value;
        }
      }),
    );
  }

  @override
  void dispose() {
    _progressNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bíblia Sagrada',
          style: GoogleFonts.ptSans(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _loadBible(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SkeletonText(height: 28, width: 200),
                    const SizedBox(height: 8),
                    SkeletonText(height: 16, width: 100),
                    const SizedBox(height: 32),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        children: const [
                          SkeletonCard(),
                          SkeletonCard(),
                          SkeletonCard(),
                          SkeletonCard(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Column(
                children: [
                  Text(
                    "BÍBLIA SAGRADA",
                    style: GoogleFonts.ptSans(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    "Versão ACF",
                    style: GoogleFonts.ptSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(height: 32),
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: [
                      GestureDetector(
                        child: Card(
                          elevation: 4,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: Theme.of(context).brightness == Brightness.light
                                    ? AppTheme.lightReadingGradient
                                    : AppTheme.darkReadingGradient,
                              ),
                            ),
                            child: Stack(
                              alignment: AlignmentDirectional.bottomCenter,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const FaIcon(
                                      FontAwesomeIcons.bookBible, 
                                      size: 56,
                                      color: Colors.white,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        'Leitura',
                                        style: GoogleFonts.ptSans(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                                child: ValueListenableBuilder<double>(
                                  valueListenable: _progressNotifier,
                                  builder: (_, state, child) {
                                    return SimpleProgressBar(
                                      progress: state,
                                      height: 12,
                                      filledColor: Theme.of(context).colorScheme.secondary,
                                      emptyColor: Theme.of(context).brightness == Brightness.dark
                                          ? const Color(0xFF3C3C3C)
                                          : const Color(0xFFE8E0D6),
                                    );
                                  },
                                ),
                              ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => MultiRepositoryProvider(
                                    providers: [
                                      RepositoryProvider.value(
                                        value: context.read<BibleRepository>(),
                                      ),
                                      RepositoryProvider.value(
                                        value:
                                            context
                                                .read<SharedPreferencesAsync>(),
                                      ),
                                    ],
                                    child: BibleScreen(
                                      progressNotifier: _progressNotifier,
                                    ),
                                  ),
                            ),
                          );
                        },
                      ),
                      GestureDetector(
                        child: Card(
                          elevation: 4,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: Theme.of(context).brightness == Brightness.light
                                    ? AppTheme.lightBookmarkGradient
                                    : AppTheme.darkBookmarkGradient,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const FaIcon(
                                  FontAwesomeIcons.bookBookmark, 
                                  size: 56,
                                  color: Colors.white,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    'Marcações',
                                    style: GoogleFonts.ptSans(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => MultiRepositoryProvider(
                                    providers: [
                                      RepositoryProvider.value(
                                        value: context.read<BibleRepository>(),
                                      ),
                                      RepositoryProvider.value(
                                        value:
                                            context
                                                .read<SharedPreferencesAsync>(),
                                      ),
                                    ],
                                    child: BookmarkScreen(
                                      progressNotifier: _progressNotifier,
                                    ),
                                  ),
                            ),
                          );
                        },
                      ),
                      GestureDetector(
                        child: Card(
                          elevation: 4,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: Theme.of(context).brightness == Brightness.light
                                    ? AppTheme.lightSavedGradient
                                    : AppTheme.darkSavedGradient,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const FaIcon(
                                  FontAwesomeIcons.solidFloppyDisk,
                                  size: 56,
                                  color: Colors.white,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    'Passagens Salvas',
                                    style: GoogleFonts.ptSans(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (_) => const SavedVersesScreen(),
                          //   ),
                          // );
                        },
                      ),
                      GestureDetector(
                        child: Card(
                          elevation: 4,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: Theme.of(context).brightness == Brightness.light
                                    ? AppTheme.lightSettingsGradient
                                    : AppTheme.darkSettingsGradient,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const FaIcon(
                                  FontAwesomeIcons.gear, 
                                  size: 56,
                                  color: Colors.white,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    'Configurações',
                                    style: GoogleFonts.ptSans(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ConfigurationScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      // bottomNavigationBar: BlocBuilder<BannerAdCubit, BannerAdState>(
      //   builder: (context, state) {
      //     if (state is BannerAdLoadedState) {
      //       return SizedBox(
      //         width: AdSize.banner.width.toDouble(),
      //         height: AdSize.banner.height.toDouble(),
      //         child: AdWidget(ad: AdHelper.mainMenuBannerAd!.bannerAd!),
      //       );
      //     }
      //     return const SizedBox.shrink();
      //   },
      // ),
    );
  }
}
