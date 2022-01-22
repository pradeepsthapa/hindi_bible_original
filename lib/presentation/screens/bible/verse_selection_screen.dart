import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindi_bible/logics/bible_state_controller.dart';
import 'package:hindi_bible/logics/providers.dart';
import 'package:hindi_bible/model/bible_names_model.dart';
import 'package:hindi_bible/presentation/widgets/native_widget.dart';

class VerseSelectionScreen extends ConsumerStatefulWidget {
  final List<BibleNamesModel> books;
  const VerseSelectionScreen({Key? key,required this.books}) : super(key: key);

  @override
  ConsumerState createState() => _VerseSelectionScreenState();
}

class _VerseSelectionScreenState extends ConsumerState<VerseSelectionScreen> with SingleTickerProviderStateMixin{

  late final TabController _tabController;
  late int _currentIndex = 0;

  Widget _tabText(String s) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(s),
    );
  }
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3,initialIndex: 0, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: _tabController.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text(_currentIndex==0?"Select Book":(_currentIndex==1?"Select Chapter":"Select Verse")),
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                _tabText("BOOKS"),
                _tabText("CHAPTERS"),
                _tabText("VERSES"),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              ListView(
                padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 9),
                children: [
                  Text("OLD TESTAMENT",style: Theme.of(context).textTheme.headline6?.copyWith(color: Theme.of(context).colorScheme.secondaryVariant),),
                  _BookGridView(books: widget.books.getRange(0, 39).toList(),tabController: _tabController,),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text("NEW TESTAMENT",style: Theme.of(context).textTheme.headline6?.copyWith(color: Theme.of(context).colorScheme.secondaryVariant),),
                  ),
                  _BookGridView(books: widget.books.getRange(39, 66).toList(),tabController: _tabController),
                ],
              ),
              _ChapterView(tabController: _tabController),
              const _VerseView(),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(interstitialAdProvider).showMainAds();
            },
            child: const Icon(Icons.check),),
          bottomNavigationBar: const NativeBannerAdWidget(),
        ));
  }
}


class _BookGridView extends ConsumerWidget {
  final List<BibleNamesModel> books;
  final TabController tabController;
  const _BookGridView({Key? key, required this.books, required this.tabController}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GridView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount: books.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisExtent: 50,
          crossAxisCount: 3),
      itemBuilder: (context,index){
        final book = books[index];
        return Padding(
          padding: const EdgeInsets.all(3.0),
          child: OutlinedButton(onPressed: (){
            ref.read(boxStorageNotifier).saveBookIndex(book.bookNumber!);
            ref.read(boxStorageNotifier).saveChapterIndex(1);
            SchedulerBinding.instance!.addPostFrameCallback((_) {
              ref.read(pageControllerProvider).jumpToPage(0);
            });
            tabController.animateTo(1);
          },
              style: OutlinedButton.styleFrom(
                  side: BorderSide(color: isDark?Colors.white70:Theme.of(context).primaryColor,width: 0.7),
                  elevation: 3,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                  backgroundColor: Theme.of(context).cardColor
              ),
              child: Text(book.longName??'',textAlign: TextAlign.center,style: TextStyle(color: Theme.of(context).colorScheme.secondary),)),
        );
      },
    );
  }
}

class _ChapterView extends ConsumerWidget {
  final TabController tabController;
  const _ChapterView({Key? key, required this.tabController}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bible = ref.watch(bibleStateProvider);
    if (bible is BibleLoaded){
      final chapters = bible.loadedBible.where((element) => element.bookNumber==ref.watch(bookIndexProvider)).toList();
      final List<int> chapterNumbers = chapters.map((e) => e.chapter!).toSet().toList();
      return GridView.builder(
          itemCount: chapterNumbers.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisExtent: 50,
              crossAxisCount: 4),
          itemBuilder: (context,index){
            final chapter = chapterNumbers[index];
            return Padding(
              padding: const EdgeInsets.all(3.0),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    side: BorderSide(color: isDark?Colors.white70:Theme.of(context).primaryColor,width: 0.7),
                    elevation: 3,
                    shadowColor: Colors.black26,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                    backgroundColor: Theme.of(context).cardColor
                ),
                onPressed: () {
                  ref.read(boxStorageNotifier).saveChapterIndex(chapter);
                  ref.read(pageControllerProvider).jumpToPage(chapter-1);
                  tabController.animateTo(2);
                },
                child: Text(chapter.toString(),style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
              ),
            );
          });
    }
    return const SizedBox.shrink();
  }
}

class _VerseView extends ConsumerWidget {
  const _VerseView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bible = ref.watch(bibleStateProvider);
    if (bible is BibleLoaded){
      final chapters = bible.loadedBible.where((element) => element.bookNumber==ref.watch(bookIndexProvider)).toList();
      final l = chapters.where((element) => element.chapter==ref.watch(chapterNumberProvider)).toList();
      final List<int> verseNumber = l.map((e) => e.verse!).toSet().toList();
      return GridView.builder(
          itemCount: verseNumber.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisExtent: 50,
              crossAxisCount: 4),
          itemBuilder: (context,index){
            final int verse = verseNumber[index];
            return Padding(
              padding: const EdgeInsets.all(3.0),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    side: BorderSide(color: isDark?Colors.white70:Theme.of(context).primaryColor,width: 0.7),
                    elevation: 3,
                    shadowColor: Colors.black26,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                    backgroundColor: Theme.of(context).cardColor
                ),
                onPressed: () {
                  Navigator.pop(context);
                  SchedulerBinding.instance!.addPostFrameCallback((_) {
                    ref.read(scrollController).scrollTo(index:verse-1, duration: const Duration(milliseconds: 400),curve: Curves.easeOut);
                  });
                  ref.read(interstitialAdProvider).showMainAds();
                },
                child: Text(verse.toString(),style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
              ),
            );
          });
    }
    return const SizedBox.shrink();
  }
}