import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindi_bible/logics/bible_state_controller.dart';
import 'package:hindi_bible/logics/providers.dart';
import 'package:hindi_bible/presentation/screens/bible/verse_viewer_screen.dart';
import 'package:hindi_bible/presentation/screens/main_drawer.dart';
import 'package:hindi_bible/presentation/widgets/banner_widget.dart';
import 'package:hindi_bible/presentation/widgets/custom_appbar_widget.dart';

class BibleLoadedScreen extends ConsumerWidget {
  final BibleLoaded bibleState;
  const BibleLoadedScreen({Key? key, required this.bibleState}) : super(key: key);


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookNumber = ref.watch(bookIndexProvider);
    final allVerses = bibleState.loadedBible.where((element) => element.bookNumber==bookNumber).toList();
    final commentaryVerses = bibleState.loadedCommentary.where((element) => element.bookNumber==bookNumber).toList();
    final selectedStories = bibleState.bibleStories.where((element) => element.bookNumber==bookNumber).toList();
    final totalChapters = allVerses.map((e) => e.chapter).toSet().toList();
    return Scaffold(
      appBar: PreferredSize(preferredSize: const Size.fromHeight(50),
        child: CustomAppBar(bibleNames: bibleState.bibleBooks),),
      drawer: const MainDrawer(),
      body: PageView.builder(
          controller: ref.watch(pageControllerProvider),
          itemCount: totalChapters.length,
          onPageChanged: (int pageNumber){
            ref.read(boxStorageNotifier).saveChapterIndex(pageNumber+1);
          },
          itemBuilder: (context,pageIndex){
            final verses = allVerses.where((element) => element.chapter==pageIndex+1).toList();
            final commentary = commentaryVerses.where((element) => element.chapterNumberFrom==pageIndex+1).toList();
            final stories = selectedStories.where((element) => element.chapter==pageIndex+1).toList();
            return VerseViewerScreen(verses: verses, commentaries: commentary, stories: stories,books: bibleState.bibleBooks);
          }),
      bottomNavigationBar: const BannerWidget(),
    );
  }
}
