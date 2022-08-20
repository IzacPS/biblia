import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class SavedVersesScreen extends StatelessWidget {
  const SavedVersesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Salvos'),
      ),
      body: ListView.separated(
        itemCount: 10,
        separatorBuilder: (context, index) {
          return Divider();
        },
        itemBuilder: (context, index) {
          return ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text('Genesis 1'), Text('[1, 2, 4, 5]')],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                // pagesData[state.bookmarks[index]].bookmarked = false;
                // context.read<Database?>()?.delete('bookmarks',
                //     where: 'pagedataindex = ?',
                //     whereArgs: [
                //       state.bookmarks[index]
                //     ]).then((value) =>
                //     {context.read<BookmarkScreenChangerCubit>().load()});
              },
            ),
          );
        },
      ),
    );
  }
}
