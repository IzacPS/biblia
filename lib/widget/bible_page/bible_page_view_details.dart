// ignore: must_be_immutable
import 'package:biblia/cubit/select_verse/select_verse_cubit.dart';
import 'package:biblia/cubit/state/state_cubit.dart';
import 'package:biblia/repo/models/bible/bible.dart';
import 'package:biblia/repo/models/bible_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class BiblePageViewDetails extends StatelessWidget {
  final Bible bible;
  final BiblePageData pagesData;
  final int selectedVerseIndex;
  int selected = 0;
  List<bool> selectedVerses = List.filled(30, false);
  Map<int, String> selectedVersesToPrint = {};

  BiblePageViewDetails(this.bible, this.pagesData,
      {Key? key, this.selectedVerseIndex = -1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var b = pagesData.book;
    var c = pagesData.chapter;
    var f = pagesData.fromVerse;
    var t = pagesData.toVerse;
    var itemCount = (t - f + 1);

    // if (selectedVerseIndex > -1) {
    //   selected = true;
    //   context.read<FabStateCubit>().setState(true);
    //   context.read<SelectVerseCubit>().selectIndex(selectedVerseIndex);
    // } else {
    //   selected = false;
    // }

    return Container(
      color: Colors.white,
      child:
          BlocBuilder<SelectVerseCubit, SelectVerseState>(builder: (_, state) {
        return ListView.builder(
            //shrinkWrap: true,
            //physics: const NeverScrollableScrollPhysics(),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              var idx = f + index;
              return Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 4, bottom: 4),
                child: GestureDetector(
                  child: Text(
                    '${idx + 1}  ${bible.books[b].chapters[c].verses[idx].description}',
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.ptSans(
                        fontSize: 18,
                        fontWeight: (selectedVerses[index])
                            ? FontWeight.bold
                            : FontWeight.normal),
                  ),
                  onTap: () {
                    if (!selectedVerses[index]) {
                      selectedVerses[index] = true;
                      selectedVersesToPrint[index] =
                          '${idx + 1}  ${bible.books[b].chapters[c].verses[idx].description}';
                      selected++;
                    } else {
                      selectedVerses[index] = false;
                      selectedVersesToPrint.remove(index);
                      selected--;
                    }
                    if (selected > 0) {
                      context
                          .read<FabStateCubit>()
                          .setState(true, selectedVersesToPrint);
                    } else {
                      context.read<FabStateCubit>().setState(false, {});
                    }
                    context.read<SelectVerseCubit>().update();
                  },
                ),
              );
            });
      }),
    );
  }
}
