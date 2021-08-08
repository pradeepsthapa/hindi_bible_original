import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindi_bible/constants/hex_color.dart';
import 'package:hindi_bible/logics/providers.dart';
import 'package:hindi_bible/model/bible_model.dart';
import 'package:hindi_bible/presentation/widgets/custom_appbar_widget.dart';
import 'main_drawer.dart';
import 'verse_viewer_screen.dart';

class BookLoadedScreen extends StatelessWidget {
  final List<Biblebook> books;
  final Information? information;
  BookLoadedScreen(this.books, this.information);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      drawer: MainDrawer(information!),
      appBar: PreferredSize(preferredSize: Size.fromHeight(52), child: CustomAppBar(books)),
      body: Consumer(
        builder: (context,watch,child) {
          final List list = books[watch(bookIndexProvider).state].chapter;
          final List<ChapterElement> chapters = list.map((e) => ChapterElement.fromJson(e)).toList();
          return Container(
            color: isDark?null:HexColor(watch(colorProvider).state),
            child: PageView.builder(
                controller: watch(pageController),
                itemCount: chapters.length,
                onPageChanged: (page){
                  final currentPage = (page+1).toString();
                  context.read(chapterNumberProvider).state = currentPage;
                  context.read(boxStorageProvider).saveChapterIndex(currentPage);
                },
                itemBuilder: (context,pageIndex){
                  final verses = chapters[pageIndex];

                  return VerseViewerScreen(verses.vers!);
                },
            ),
          );
        }
      ),
    );
  }
}
