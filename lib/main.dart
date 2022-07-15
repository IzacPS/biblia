import 'package:biblia/bloc/app_starter/app_starter_bloc.dart';
import 'package:biblia/bloc/bible_page_changer/bible_page_changer_bloc.dart';
import 'package:biblia/cubit/read_progress/read_progress_cubit.dart';
import 'package:biblia/repo/bible_repo/bible_repo.dart';
import 'package:biblia/widget/bible_page/bible_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = openDatabase(
    join(await getDatabasesPath(), 'biblia.db'),
    onCreate: (db, version) {
      return db.execute('CREATE TABLE IF NOT EXISTS saved_verses (id INTEGER '
          'PRIMARY KEY AUTOINCREMENT, book INTEGER, chapter '
          'INTEGER, verse INTEGER)');
    },
    version: 1,
  );

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
              RepositoryProvider.value(value: database),
            ],
            child: MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => AppStarterBloc()),
                BlocProvider(
                    create: (context) => BiblePageChangerBloc(
                        context.read<BibleRepository>().pagesData.length)),
                BlocProvider(create: (_) => ReadProgressCubit()),
              ],
              child: const App(),
            ),
          ),
        ),
        storage: storage,
      );
    },
  );
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
                  .loadBible()
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
                        MaterialPageRoute(builder: (_) => const BiblePage()))
                    .then((value) {
                  context.read<ReadProgressCubit>().updateProgress(
                      context.read<BiblePageChangerBloc>().state.pageIndex /
                          context.read<BiblePageChangerBloc>().maxSize);
                });
              },
            ),
          ),
          Card(
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
          ),
          Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                FaIcon(
                  FontAwesomeIcons.bookmark,
                  size: 56,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text('Passagens Salvas'),
                ),
              ],
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
    );
    //return const TestWidget();
  }
}
