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
        if (value != null) _progressNotifier.value = value;
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
      appBar: AppBar(),
      body: FutureBuilder(
        future: _loadBible(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Column(
                children: [
                  Text(
                    "BÍBLIA SAGRADA",
                    style: GoogleFonts.ptSans(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Versão ACF",
                    style: GoogleFonts.ptSans(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 32),
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    children: [
                      GestureDetector(
                        child: Card(
                          child: Stack(
                            alignment: AlignmentDirectional.bottomCenter,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FaIcon(FontAwesomeIcons.bookBible, size: 56),
                                  Padding(
                                    padding: EdgeInsets.only(top: 8),
                                    child: Text(
                                      'Leitura',
                                      style: GoogleFonts.ptSans(),
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
                                    return LinearProgressIndicator(
                                      minHeight: 8,
                                      value: state,
                                    );
                                  },
                                ),
                              ),
                            ],
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(FontAwesomeIcons.bookBookmark, size: 56),
                              Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: Text(
                                  'Marcações',
                                  style: GoogleFonts.ptSans(),
                                ),
                              ),
                            ],
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
                      Card(
                        child: GestureDetector(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.solidFloppyDisk,
                                size: 56,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: Text(
                                  'Passagens Salvas',
                                  style: GoogleFonts.ptSans(),
                                ),
                              ),
                            ],
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
                      ),
                      Card(
                        child: GestureDetector(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(FontAwesomeIcons.gear, size: 56),
                              Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: Text(
                                  'Configurações',
                                  style: GoogleFonts.ptSans(),
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ConfigurationScreen(),
                              ),
                            );
                          },
                        ),
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
