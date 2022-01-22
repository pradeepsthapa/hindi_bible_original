import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindi_bible/logics/providers.dart';
import 'package:hindi_bible/model/bible_names_model.dart';
import 'package:hindi_bible/presentation/screens/bible/favourites_screen.dart';
import 'package:hindi_bible/presentation/screens/bible/verse_selection_screen.dart';
import 'package:hindi_bible/presentation/widgets/settings_widget.dart';

class CustomAppBar extends ConsumerWidget {
  final List<BibleNamesModel> bibleNames;
  const CustomAppBar({Key? key, required this.bibleNames}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentBook = bibleNames.firstWhere((element) => element.bookNumber==ref.watch(bookIndexProvider));
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(onPressed: (){
            if(currentBook.bookNumber!=10){
              final prevBook = bibleNames.indexOf(currentBook)-1;
              ref.read(boxStorageNotifier).saveChapterIndex(1);
              ref.read(boxStorageNotifier).saveBookIndex(bibleNames[prevBook].bookNumber!);
            }
          }, icon: const Icon(Icons.chevron_left),padding: EdgeInsets.zero,),
          GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>VerseSelectionScreen(books: bibleNames)));
              },
              child: Text(currentBook.shortName!+'.  ${ref.watch(chapterNumberProvider)}:${ref.watch(currentVerseProvider)+1}')),
          IconButton(onPressed: (){
            if(currentBook.bookNumber!=730){
              final nextBook = bibleNames.indexOf(currentBook)+1;
              ref.read(boxStorageNotifier).saveChapterIndex(1);
              ref.read(boxStorageNotifier).saveBookIndex(bibleNames[nextBook].bookNumber!);
            }
          },
              icon: const Icon(Icons.chevron_right),padding: EdgeInsets.zero),
        ],
      ),
      actions: [
        IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return const BookmarkScreen();
              }));
            }, icon: const Icon(CupertinoIcons.bookmark,)),
        IconButton(
            padding: const EdgeInsets.only(right: 12),
            onPressed: (){
              SettingWidget.showSettingsDialog(context:context);
            }, icon: const Icon(CupertinoIcons.settings_solid)),
      ],
    );
  }
}
