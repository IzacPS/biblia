import 'package:biblia/cubit/dropdown_menu_select/dropdown_menu_select_cubit.dart';
import 'package:biblia/repo/bible_repo/bible_repo.dart';
import 'package:biblia/repo/models/bible/bible.dart';
import 'package:biblia/repo/models/bible_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Tag-value used for the add todo popup button.
const String _heroAddTodo = 'add-todo-hero';

/// {@template add_todo_popup_card}
/// Popup card to add a new [Todo]. Should be used in conjuction with
/// [HeroDialogRoute] to achieve the popup effect.
///
/// Uses a [Hero] with tag [_heroAddTodo].
/// {@endtemplate}
// ignore: must_be_immutable
class PopupCard extends StatelessWidget {
  /// {@macro add_todo_popup_card}
  int book = -1;
  int chapter = -1;
  int verse = -1;
  PopupCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSalm = false;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: _heroAddTodo,
          // createRectTween: (begin, end) {
          //   return CustomRectTween(begin: begin, end: end);
          // },
          child: Material(
            type: MaterialType.card,
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 8),
                      child: Text(
                        'Livro',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    BlocBuilder<DropdownMenuSelectCubit<Book>,
                        DropdownMenuSelectState<Book>>(
                      builder: (_, state) {
                        //debugPrint(state.value?.name);

                        book = state.value?.id ?? -1;
                        return DropdownButtonFormField<Book>(
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  width: 1,
                                  //color: Colors.purple,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  width: 3,
                                  //color: Colors.purple,
                                ),
                              ),
                            ),
                            value: state.value,
                            items: state.list
                                ?.map((e) => DropdownMenuItem<Book>(
                                    value: e, child: Text(e.name)))
                                .toList(),
                            onChanged: (value) {
                              context
                                  .read<DropdownMenuSelectCubit<Book>>()
                                  .setValue(
                                      value,
                                      RepositoryProvider.of<BibleRepository>(
                                              context)
                                          .bible
                                          .books);
                              context
                                  .read<DropdownMenuSelectCubit<Chapter>>()
                                  .setValue(
                                      value?.chapters[0], value?.chapters);
                            });
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 8),
                      child: Text(
                        'Capítulo',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    BlocBuilder<DropdownMenuSelectCubit<Chapter>,
                        DropdownMenuSelectState<Chapter>>(
                      builder: (_, state) {
                        chapter = state.value?.id ?? -1;
                        return DropdownButtonFormField<Chapter>(
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  width: 1,
                                  //color: Colors.purple,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  width: 3,
                                  //color: Colors.purple,
                                ),
                              ),
                            ),
                            value: state.value,
                            items: state.list
                                ?.map((e) => DropdownMenuItem<Chapter>(
                                    value: e,
                                    child: Text((book == 18)
                                        ? 'Salmo ${e.id + 1}'
                                        : 'Capítulo ${(e.id + 1).toString()}')))
                                .toList(),
                            onChanged: (value) {
                              context
                                  .read<DropdownMenuSelectCubit<Chapter>>()
                                  .setValue(value, state.list);
                              context
                                  .read<DropdownMenuSelectCubit<Verse>>()
                                  .setValue(value?.verses[0], value?.verses);
                            });
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 8),
                      child: Text(
                        'Versículo',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    BlocBuilder<DropdownMenuSelectCubit<Verse>,
                        DropdownMenuSelectState<Verse>>(
                      builder: (_, state) {
                        verse = state.value?.id ?? -1;
                        return DropdownButtonFormField<Verse>(
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  width: 1,
                                  //color: Colors.purple,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  width: 3,
                                  //color: Colors.purple,
                                ),
                              ),
                            ),
                            value: state.value,
                            items: state.list
                                ?.map((e) => DropdownMenuItem<Verse>(
                                    value: e,
                                    child: Text(
                                        '${(book == 18) ? 'Verso' : 'Versículo'} ${(e.id + 1).toString()}')))
                                .toList(),
                            onChanged: (value) {
                              context
                                  .read<DropdownMenuSelectCubit<Verse>>()
                                  .setValue(value, state.list);
                            });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 4),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop<BiblePageDataSearch>(context,
                              BiblePageDataSearch(book, chapter, verse));
                        },
                        child: const Text('Search'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
