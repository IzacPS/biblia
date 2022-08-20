import 'package:biblia/ad/ad_helper.dart';
import 'package:biblia/bloc/app_starter/app_starter_bloc.dart';
import 'package:biblia/bloc/bible_page_changer/bible_page_changer_bloc.dart';
import 'package:biblia/cubit/banner_ad/banner_ad_cubit.dart';
import 'package:biblia/cubit/bookmark_screen_changer/bookmark_screen_changer_cubit.dart';
import 'package:biblia/cubit/read_progress/read_progress_cubit.dart';
import 'package:biblia/repo/bible_repo/bible_repo.dart';
import 'package:biblia/widget/bible_page/bible_page.dart';
import 'package:biblia/widget/bookmark_screen/bookmark_screen.dart';
import 'package:biblia/widget/saved_verses/saved_verses.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize().then((value) => {AdHelper.init()});
  Database? database;
  await openDatabase(
    join(await getDatabasesPath(), 'biblia.db'),
    onCreate: (db, version) async {
      await db.execute('CREATE TABLE IF NOT EXISTS saved (id INTEGER '
          'PRIMARY KEY AUTOINCREMENT, description TEXT, data TEXT)');
      await db.execute('CREATE TABLE IF NOT EXISTS bookmarks (id INTEGER '
          'PRIMARY KEY AUTOINCREMENT, pagedataindex INTEGER)');
    },
    version: 1,
  ).then((value) => database = value);

  final storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (value) {
      HydratedBlocOverrides.runZoned(
        () => runApp(
          MultiRepositoryProvider(
            providers: [
              RepositoryProvider<BibleRepository>(
                  create: (_) => BibleRepository()),
              RepositoryProvider<Database?>.value(value: database),
            ],
            child: MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => AppStarterBloc()),
                BlocProvider(
                    create: (context) => BiblePageChangerBloc(
                        context.read<BibleRepository>().pagesData.length)),
                BlocProvider(create: (_) => ReadProgressCubit()),
                BlocProvider(create: (_) => BookmarkScreenChangerCubit()),
                BlocProvider(create: (_) => BannerAdCubit()),
                BlocProvider(create: (_) => BannerAdPageCubit()),
              ],
              child: const App(),
            ),
          ),
        ),
        storage: storage,
      );
    },
  );
  //TODO: uncomment when ad is ready
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: BlocBuilder<AppStarterBloc, AppStarterState>(
        builder: ((context, state) {
          Widget w = Container();
          switch (state.status) {
            case StarterStateStatus.initial:
              context.read<AppStarterBloc>().add(AppStarterLoadingEvent());
              RepositoryProvider.of<BibleRepository>(context).setScreenSize(
                  MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height);

              RepositoryProvider.of<BibleRepository>(context)
                  .loadBible(context.read<Database?>())
                  .then((value) {
                context.read<AppStarterBloc>().add(AppStarterSuccessEvent());
              });
              break;
            case StarterStateStatus.update:
            case StarterStateStatus.success:
              w = HomePage();
              break;
            case StarterStateStatus.loading:
              // TODO: Handle this case.
              break;
            case StarterStateStatus.failure:
              // TODO: Handle this case.
              break;
          }
          return w;
        }),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  //double progress = 0.0;
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AdHelper.mainMenuBannerAd?.setOnReadyCallback(() {
      context.read<BannerAdCubit>().loaded();
    });
    AdHelper.pageBannerList?.setOnReadyCallback(() {
      context.read<BannerAdPageCubit>().loaded();
    });
    AdHelper.loadMenuBanner();

    double progress = context.read<BiblePageChangerBloc>().state.pageIndex /
        context.read<BiblePageChangerBloc>().maxSize;
    context.read<ReadProgressCubit>().updateProgress(progress);

    return Scaffold(
        appBar: AppBar(),
        body: GridView.count(
          crossAxisCount: 2,
          children: [
            Card(
              child: GestureDetector(
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        FaIcon(
                          FontAwesomeIcons.bookBible,
                          size: 56,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text('Biblia Sagrada'),
                        ),
                      ],
                    ),
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(3),
                        bottomRight: Radius.circular(3),
                      ),
                      child: BlocBuilder<ReadProgressCubit, ReadProgressState>(
                        builder: (context, state) {
                          return LinearProgressIndicator(
                            minHeight: 8,
                            value: state.progress,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const BiblePage()));
                  //     .then((value) {
                  //   context.read<ReadProgressCubit>().updateProgress(
                  //       context.read<BiblePageChangerBloc>().state.pageIndex /
                  //           context.read<BiblePageChangerBloc>().maxSize);
                  // });
                },
              ),
            ),
            Card(
              child: GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    FaIcon(
                      FontAwesomeIcons.bookBookmark,
                      size: 56,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text('Marcações'),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const BookmarkScreen()));
                },
              ),
            ),
            Card(
              child: GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    FaIcon(
                      FontAwesomeIcons.floppyDisk,
                      size: 56,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text('Passagens Salvas'),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const SavedVersesScreen()));
                },
              ),
            ),
            Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  FaIcon(
                    FontAwesomeIcons.gear,
                    size: 56,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text('Configurações'),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BlocBuilder<BannerAdCubit, BannerAdState>(
          builder: (context, state) {
            if (state is BannerAdLoadedState) {
              return SizedBox(
                width: AdSize.banner.width.toDouble(),
                height: AdSize.banner.height.toDouble(),
                child: AdWidget(ad: AdHelper.mainMenuBannerAd!.bannerAd!),
              );
            }
            return const SizedBox.shrink();
          },
        ));
  }
}
