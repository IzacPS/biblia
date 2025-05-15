import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/bible.dart';
import '../model/bible_page.dart';

class BiblePageViewDetails extends StatefulWidget {
  const BiblePageViewDetails({
    super.key,
    required this.bible,
    required this.pagesData,
  });

  final Bible bible;
  final BiblePageData pagesData;
  @override
  State<BiblePageViewDetails> createState() => _BiblePageViewDetailsState();
}

class _BiblePageViewDetailsState extends State<BiblePageViewDetails> {
  int selected = 0;

  List<bool> selectedVerses = List.filled(30, false);

  Map<int, String> selectedVersesToPrint = {};

  @override
  Widget build(BuildContext context) {
    var b = widget.pagesData.book;
    var c = widget.pagesData.chapter;
    var f = widget.pagesData.fromVerse;
    var t = widget.pagesData.toVerse;
    var itemCount = (t - f + 1);

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        var idx = f + index;
        return Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 4,
            bottom: 4,
          ),
          child: GestureDetector(
            child: Text(
              '${idx + 1}  ${widget.bible.books[b].chapters[c].verses[idx].description}',
              textAlign: TextAlign.justify,
              style: GoogleFonts.ptSans(
                fontSize: 18,
                fontWeight:
                    (selectedVerses[index])
                        ? FontWeight.bold
                        : FontWeight.normal,
                shadows:
                    selectedVerses[index]
                        ? [
                          Shadow(
                            offset: Offset(0, 2),
                            blurRadius: 4,
                            color: Colors.black26,
                          ),
                        ]
                        : [],
              ),
            ),
            onTap: () {
              if (!selectedVerses[index]) {
                setState(() {
                  selectedVerses[index] = true;
                });
                selectedVersesToPrint[index] =
                    '${idx + 1}  ${widget.bible.books[b].chapters[c].verses[idx].description}';
                selected++;
              } else {
                setState(() {
                  selectedVerses[index] = false;
                });
                selectedVersesToPrint.remove(index);
                selected--;
              }
            },
          ),
        );
      },
    );
  }
}
