import 'package:biblia/ad/ad_helper.dart';
import 'package:biblia/bloc/bible_page_changer/bible_page_changer_bloc.dart';
import 'package:biblia/cubit/banner_ad/banner_ad_cubit.dart';
import 'package:biblia/cubit/bookmark_state/bookmark_state_cubit.dart';
import 'package:biblia/cubit/dropdown_menu_select/dropdown_menu_select_cubit.dart';
import 'package:biblia/cubit/read_progress/read_progress_cubit.dart';
import 'package:biblia/cubit/select_verse/select_verse_cubit.dart';
import 'package:biblia/cubit/state/state_cubit.dart';
import 'package:biblia/repo/bible_repo/bible_repo.dart';
import 'package:biblia/repo/models/bible/bible.dart';
import 'package:biblia/repo/models/bible_page.dart';
import 'package:biblia/widget/bible_page/bible_page_view_details.dart';
import 'package:biblia/widget/bible_page_search/hero_dialog_route.dart';
import 'package:biblia/widget/bible_page_search/popup_card.dart';
import 'package:biblia/widget/expandable_fab/expandable_fab.dart';
import 'package:flip_widget/flip_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';

class BiblePage extends StatelessWidget {
  const BiblePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: context.read<BiblePageChangerBloc>()),
        BlocProvider(create: (_) {
          return SelectVerseCubit();
        }),
        BlocProvider(create: (_) {
          return FabStateCubit();
        }),
        BlocProvider(create: (_) {
          return BookmarkStateCubit();
        })
      ],
      child: const BiblePageView(),
    );
  }
}

class BiblePageView extends StatefulWidget {
  const BiblePageView({Key? key}) : super(key: key);

  @override
  State<BiblePageView> createState() => _BiblePageState();
}

class _BiblePageState extends State<BiblePageView>
    with TickerProviderStateMixin {
  final GlobalKey<FlipWidgetState> _flipPageNextKey = GlobalKey();
  final GlobalKey<FlipWidgetState> _flipPagePrevKey = GlobalKey();

  late AnimationController _nextPageController;
  late AnimationController _prevPageController;

  bool bookmarked = false;

  int index = 0;
  bool searchClicked = false;
  double tween = 0;
  late Bible bible;
  late List<BiblePageData> pagesData;

  @override
  void initState() {
    super.initState();
    _nextPageController = AnimationController(
      value: 0,
      lowerBound: 0.0,
      upperBound: 1.0,
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _nextPageController.stop();
    _nextPageController.addListener(() {
      _flipPageNextKey.currentState?.flip(_nextPageController.value * 1.5, 5);
    });

    _prevPageController = AnimationController(
      value: 0,
      lowerBound: 0,
      upperBound: 1.0,
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _prevPageController.stop();
    _prevPageController.addListener(() {
      _flipPagePrevKey.currentState?.flip(_prevPageController.value * 1.5, 5);
    });
  }

  @override
  void dispose() {
    _nextPageController.dispose();
    _prevPageController.dispose();
    super.dispose();
  }

  Future<void> updateProgress(BuildContext context) async {
    context.read<ReadProgressCubit>().updateProgress(
        context.read<BiblePageChangerBloc>().state.pageIndex /
            context.read<BiblePageChangerBloc>().maxSize);
  }

  @override
  Widget build(BuildContext context) {
    AdHelper.loadPageBanner();
    bible = context.read<BibleRepository>().bible;
    pagesData = context.read<BibleRepository>().pagesData;
    return BlocBuilder<BiblePageChangerBloc, BiblePageChangerState>(
        builder: (c, state) {
      var data = pagesData[state.pageIndex];
      switch (state.pageState) {
        case ChangePageState.previousPage:
          //context.read<SelectVerseCubit>().unselectAll();
          context.read<FabStateCubit>().setState(false, {});
          index = 1;
          _flipPagePrevKey.currentState?.startFlip().then((value) {
            _prevPageController.value = 0;
            _prevPageController.forward().then((value) {
              context
                  .read<BiblePageChangerBloc>()
                  .add(const BibleChangePageDecrementEvent());
              _flipPagePrevKey.currentState?.stopFlip();
            });
            //});
          });
          updateProgress(context);
          break;
        case ChangePageState.nextPage:
          //context.read<SelectVerseCubit>().unselectAll();
          context.read<FabStateCubit>().setState(false, {});
          index = 0;
          _flipPageNextKey.currentState?.startFlip().then((value) {
            _nextPageController.value = 0;
            _nextPageController.forward().then((value) {
              context
                  .read<BiblePageChangerBloc>()
                  .add(const BibleChangePageIncrementEvent());
              _flipPageNextKey.currentState?.stopFlip();
            });
          });
          updateProgress(context);
          break;
        case ChangePageState.increment:
        case ChangePageState.decrement:
          break;
        case ChangePageState.finalize:
        case ChangePageState.none:
        case ChangePageState.initial:
          updateProgress(context);
          // AdHelper.loadAndGetNextPageBanner(() {
          //   context.read<BannerAdPageCubit>().loaded();
          // }).then((value) => ad = value);
          break;
        case ChangePageState.exchangeStack:
          break;
        default:
      }
      //}

      return Scaffold(
          appBar: AppBar(
            title: Text(
              '${bible.books[data.book].name} ${data.chapter + 1}:${data.fromVerse + 1}-${data.toVerse + 1}',
              style: GoogleFonts.ptSans(),
            ),
            actions: [
              _biblePageBookmark(pagesData, state.pageIndex),
              _biblePageSearch(),
            ],
          ),
          body: GestureDetector(
            onPanUpdate: (details) {
              if (details.delta.dx > 0) {
                if (!_prevPageController.isAnimating ||
                    !_nextPageController.isAnimating) {
                  c
                      .read<BiblePageChangerBloc>()
                      .add(const BibleChangePagePrevEvent());
                }
              } else if (details.delta.dy < 0) {
                if (!_nextPageController.isAnimating ||
                    !_prevPageController.isAnimating) {
                  c
                      .read<BiblePageChangerBloc>()
                      .add(const BibleChangePageNextEvent());
                }
              }
            },
            child: Column(
              children: [
                Expanded(
                  child: _biblePageStack(
                    stack1Key: _flipPageNextKey,
                    stack2Key: _flipPagePrevKey,
                    stackIndex: index,
                    bible: bible,
                    pageDataS1Bottom:
                        pagesData[(state.pageIndex + 1) % state.maxSize],
                    pageDataS1Top: pagesData[state.pageIndex],
                    pageDataS2Bottom: pagesData[(state.pageIndex - 1) < 0
                        ? state.pageIndex
                        : state.pageIndex - 1],
                    pageDataS2top: pagesData[state.pageIndex],
                    selectedVerseIndex: state.selectedVerse,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                BlocBuilder<BannerAdPageCubit, BannerAdState>(
                  builder: (context, state) {
                    if (state is BannerAdLoadedState) {
                      return Container(
                        color: Colors.transparent,
                        width: AdSize.banner.width.toDouble(),
                        height: AdSize.banner.height.toDouble(),
                        child: AdWidget(ad: AdHelper.pageBannerList!.bannerAd!),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                )
              ],
            ),
          ),
          floatingActionButton:
              BlocBuilder<FabStateCubit, StateState>(builder: (_, state) {
            if (state.enabled) {
              return FloatingActionButton(
                child: const Icon(Icons.share),
                onPressed: () {
                  String str = '';
                  state.selected.forEach((key, value) {
                    str += '\n$value';
                  });
                  Share.share(str);
                },
              );
              // return SpeedDial(
              //   icon: Icons.menu,
              //   activeIcon: Icons.close,
              //   children: [
              //     SpeedDialChild(
              //       child: const Icon(Icons.save),
              //       label: 'Salvar',
              //       onTap: () {
              //         // context
              //         //     .read<Database?>()
              //         //     ?.insert('saved', {'pagedataindex': index});
              //       },
              //     ),
              //     SpeedDialChild(
              //       child: const Icon(Icons.share),
              //       label: 'Compartilhar',
              //       onTap: () {
              //         String str = '';
              //         state.selected.forEach((key, value) {
              //           str += '\n$value';
              //         });
              //         Share.share(str);
              //       },
              //     ),
              //   ],
              // );
            }
            return const SizedBox.shrink();
          }));
    });
  }

  Widget _biblePageStack(
      {required Key? stack1Key,
      required Key? stack2Key,
      required int stackIndex,
      required Bible bible,
      required BiblePageData pageDataS1Bottom,
      required BiblePageData pageDataS1Top,
      required BiblePageData pageDataS2Bottom,
      required BiblePageData pageDataS2top,
      required int selectedVerseIndex}) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        IndexedStack(
          index: stackIndex,
          children: [
            _flipFrameStack(
              key: stack1Key,
              bible: bible,
              pageDataBottom: pageDataS1Bottom,
              pageDataTop: pageDataS1Top,
              selectedVerseIndex: selectedVerseIndex,
            ),
            _flipFrameStack(
              key: stack2Key,
              bible: bible,
              pageDataBottom: pageDataS2Bottom,
              pageDataTop: pageDataS2top,
              selectedVerseIndex: selectedVerseIndex,
              leftToRight: true,
            ),
          ],
        ),
      ],
    );
  }

  Widget _flipFrameStack({
    required Key? key,
    required Bible bible,
    required BiblePageData pageDataBottom,
    required BiblePageData pageDataTop,
    required int selectedVerseIndex,
    bool leftToRight = false,
  }) {
    return Stack(
      children: [
        BiblePageViewDetails(bible, pageDataBottom),
        FlipWidget(
          leftToRight: leftToRight,
          key: key,
          child: BiblePageViewDetails(
            bible,
            pageDataTop,
            selectedVerseIndex: selectedVerseIndex,
          ),
        ),
      ],
    );
  }

  Widget _biblePageBookmark(List<BiblePageData> data, int index) {
    return Hero(
      tag: 'bible-page-bookmark-hero',
      child: Material(
        color: Colors.brown,
        child: BlocBuilder<BookmarkStateCubit, BookmarkStateState>(
            builder: ((context, state) {
          return IconButton(
            color: (data[index].bookmarked) ? Colors.yellow : Colors.white,
            onPressed: () {
              data[index].bookmarked = !data[index].bookmarked;
              context.read<BookmarkStateCubit>().update();
              if (data[index].bookmarked) {
                context
                    .read<Database?>()
                    ?.insert('bookmarks', {'pagedataindex': index});
              } else {
                context.read<Database?>()?.delete('bookmarks',
                    where: 'pagedataindex = ?', whereArgs: [index]);
              }
            },
            icon: (data[index].bookmarked)
                ? const Icon(Icons.bookmark_added)
                : const Icon(Icons.bookmark_add),
          );
        })),
      ),
    );
  }

  Widget _biblePageSearch() {
    return Hero(
      tag: 'add-todo-hero',
      child: Material(
        color: Colors.brown,
        child: IconButton(
          onPressed: () {
            Navigator.of(context)
                .push<BiblePageDataSearch>(HeroDialogRoute(builder: (context) {
              return RepositoryProvider.value(
                  value: context.read<BibleRepository>(),
                  child: MultiBlocProvider(providers: [
                    BlocProvider(
                      create: (_) => DropdownMenuSelectCubit<Book>(
                          list: context.read<BibleRepository>().bible.books),
                    ),
                    BlocProvider(
                      create: (_) => DropdownMenuSelectCubit<Chapter>(),
                    ),
                    BlocProvider(
                      create: (_) => DropdownMenuSelectCubit<Verse>(),
                    ),
                  ], child: PopupCard()));
            })).then((pageDataSearch) {
              context
                  .read<BibleRepository>()
                  .getBibleDataIndex(pageDataSearch)
                  .then((index) {
                if (index != -1) {
                  var data = context.read<BibleRepository>().pagesData[index];
                  int idx = 0;
                  for (int i = data.fromVerse; i < data.toVerse; i++, idx++) {
                    if (i == pageDataSearch!.verse) break;
                  }
                  context
                      .read<BiblePageChangerBloc>()
                      .add(BibleChangePageInitialEvent(index, idx));
                }
              });
            });
          },
          icon: const Icon(Icons.search),
        ),
      ),
    );
  }
}
