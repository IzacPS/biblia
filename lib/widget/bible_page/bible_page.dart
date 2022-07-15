import 'package:biblia/bloc/bible_page_changer/bible_page_changer_bloc.dart';
import 'package:biblia/cubit/dropdown_menu_select/dropdown_menu_select_cubit.dart';
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
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

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

  int index = 0;
  bool searchClicked = false;
  double tween = 0;

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

  @override
  Widget build(BuildContext context) {
    var bible = context.read<BibleRepository>().bible;
    var pagesData = context.read<BibleRepository>().pagesData;
    return BlocBuilder<BiblePageChangerBloc, BiblePageChangerState>(
        builder: (c, state) {
      var data = pagesData[state.pageIndex];
      switch (state.pageState) {
        case ChangePageState.previousPage:
          context.read<SelectVerseCubit>().unselect();
          context.read<FabStateCubit>().setState(false);
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
          break;
        case ChangePageState.nextPage:
          context.read<SelectVerseCubit>().unselect();
          context.read<FabStateCubit>().setState(false);
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
          break;
        case ChangePageState.increment:
        case ChangePageState.decrement:
          break;
        case ChangePageState.finalize:
        case ChangePageState.none:
        case ChangePageState.initial:
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
          floatingActionButton:
              BlocBuilder<FabStateCubit, StateState>(builder: (_, state) {
            if (state.enabled) {
              return ExpandableFab(
                distance: 112.0,
                children: [
                  FloatingActionButton(
                    heroTag: null,
                    onPressed: () {
                      Share.share('hello');
                    },
                    child: const Icon(Icons.share),
                  ),
                  FloatingActionButton(
                    heroTag: null,
                    onPressed: () {
                      //Share.share('hello');
                    },
                    child: const Icon(Icons.favorite),
                  ),
                  FloatingActionButton(
                    heroTag: null,
                    onPressed: () {
                      //Share.share('hello');
                    },
                    child: const Icon(Icons.flag),
                  ),
                ],
              );
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
