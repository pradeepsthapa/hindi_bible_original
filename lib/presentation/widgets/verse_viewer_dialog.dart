import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindi_bible/logics/bible_state_controller.dart';
import 'package:hindi_bible/logics/providers.dart';
import 'package:hindi_bible/model/bible_verses_model.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:selectable/selectable.dart';

class VerseViewerDialog{

  static void showVerseDialog(String  refLink, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final b = refLink.split(" ");
    final int bookId = int.parse(b.first.split(":").last);
    final int chapter = int.parse(b.last.split(":").first);
    final String v = b.last.split(":").last;
    int verseIndex = 1;
    if(!v.contains("-")){
      verseIndex = int.parse(b.last.split(":").last);
    }
    else{
      verseIndex = int.parse(v.split("-").first);
    }

    showModal(
        configuration: const FadeScaleTransitionConfiguration(
            transitionDuration: Duration(milliseconds: 240),
            reverseTransitionDuration: Duration(milliseconds: 150),
            barrierColor: Colors.black38,
            barrierDismissible: true),
        context: context,
        builder: (BuildContext context) {
          return Align(
            alignment: Alignment.center,
            child: Card(
              color: isDark ? Colors.grey[900] : null,
              elevation: 7,
              shadowColor: Colors.black87,
              margin: EdgeInsets.zero,
              child: SingleChildScrollView(
                child: Consumer(builder: ( context, WidgetRef ref, child) {
                  final bible = ref.watch(bibleStateProvider);
                  if(bible is BibleLoaded){
                    final verses = bible.loadedBible.where((element) => element.bookNumber==bookId&&element.chapter==chapter).toList();
                    return SizedBox(
                      height: MediaQuery.of(context).size.height *.8,
                      width: MediaQuery.of(context).size.width *.9,
                      child: Scaffold(
                          appBar: PreferredSize(
                            preferredSize: const Size.fromHeight(50),
                            child: AppBar(
                              title: Text(bible.bibleBooks.firstWhere((element) => element.bookNumber==bookId,orElse: ()=>bible.bibleBooks.first).longName!+' $chapter'+':'+v),
                            ),
                          ),
                          body: _ReferenceVerseDisplayScreen(verseIndex: verseIndex-1, verses: verses),
                        bottomNavigationBar: TextButton(onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Close",textAlign: TextAlign.end,),),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },),
              ),
            ),
          );
        });
  }
}

class _ReferenceVerseDisplayScreen extends ConsumerStatefulWidget {
  final List<BibleVersesModel> verses;
  final int verseIndex;
  const _ReferenceVerseDisplayScreen({Key? key, required this.verses, required this.verseIndex}) : super(key: key);

  @override
  ConsumerState createState() => _ReferenceVerseDisplayScreenState();
}

class _ReferenceVerseDisplayScreenState extends ConsumerState<_ReferenceVerseDisplayScreen> {


  late final ItemScrollController itemScrollController;
  late final ItemPositionsListener itemPositionsListener;

  @override
  void initState() {
    super.initState();
    itemScrollController = ItemScrollController();
    itemPositionsListener = ItemPositionsListener.create();

    SchedulerBinding.instance!.addPostFrameCallback((_) {
      if(mounted) itemScrollController.scrollTo(index:widget.verseIndex, duration: const Duration(milliseconds: 400),curve: Curves.easeOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Selectable(
      child: ScrollablePositionedList.builder(
          itemScrollController: itemScrollController,
          itemPositionsListener: itemPositionsListener,
          itemCount: widget.verses.length,
          itemBuilder: (context,index){
            final verse = widget.verses[index];
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(verse.verse.toString(),style: TextStyle(color: Theme.of(context).textTheme.caption?.color,fontSize: 12),),
                Expanded(
                  child: Html(
                    data:verse.text??'',
                    tagsList: Html.tags..addAll(['pb','t','j']),
                    style:{
                      '*':Style(
                        fontSize: FontSize(ref.watch(fontSizeProvider)),
                        margin: const EdgeInsets.symmetric(vertical: 2),
                      ),
                      'j':Style(
                          color: Colors.red
                      ),
                    },
                    customRender: {
                      'pb':(context,child){
                        return child;
                      },
                      't':(context,child){
                        return child;
                      },
                      'j':(context,child){
                        return child;
                      },
                    },
                  ),
                ),
              ],
            );
          }),
    );
  }
}