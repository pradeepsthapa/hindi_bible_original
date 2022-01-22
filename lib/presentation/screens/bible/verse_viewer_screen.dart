import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindi_bible/logics/providers.dart';
import 'package:hindi_bible/model/bible_commentaries_model.dart';
import 'package:hindi_bible/model/bible_names_model.dart';
import 'package:hindi_bible/model/bible_stories_model.dart';
import 'package:hindi_bible/model/bible_verses_model.dart';
import 'package:hindi_bible/presentation/widgets/verse_viewer_dialog.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:selectable/selectable.dart';
import 'package:share/share.dart';

class VerseViewerScreen extends ConsumerStatefulWidget {
  final List<BibleVersesModel> verses;
  final List<BibleCommentaryModel> commentaries;
  final List<BibleStoriesModel> stories;
  final List<BibleNamesModel> books;

  const VerseViewerScreen({Key? key, required this.verses,required this.commentaries,required this.stories, required this.books}) : super(key: key);

  @override
  ConsumerState createState() => _VerseViewerScreenState();
}

class _VerseViewerScreenState extends ConsumerState<VerseViewerScreen> {
  late final ItemScrollController itemScrollController;
  late final ItemPositionsListener itemPositionsListener;

  @override
  void initState() {
    super.initState();
    itemScrollController = ItemScrollController();
    itemPositionsListener = ItemPositionsListener.create();
    itemPositionsListener.itemPositions.addListener(() {
      ref.read(currentVerseProvider.state).state = itemPositionsListener.itemPositions.value.first.index;
    });
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      if(mounted) ref.read(scrollController.state).state = itemScrollController;
    });
  }

  @override
  Widget build(BuildContext context) {
    final highlights = ref.watch(bookmarksStateProvider);
    return Selectable(
      child: ScrollablePositionedList.builder(
        itemScrollController: itemScrollController,
        itemPositionsListener: itemPositionsListener,
        itemCount: widget.verses.length,
        itemBuilder: (BuildContext context, int index) {
            final verse = widget.verses[index];
            final story = widget.stories.firstWhere((element) => element.verse==verse.verse,orElse: ()=>BibleStoriesModel());
            final commentary = widget.commentaries.firstWhere((element) => element.verseNumberFrom==verse.verse,orElse: ()=>BibleCommentaryModel());
            final highlightedVerse = highlights.firstWhere((element) => element.text==verse.text,orElse: ()=>BibleVersesModel());
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Wrap(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Text(story.title??'',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondaryVariant,
                          fontSize: ref.watch(fontSizeProvider)+1),),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(verse.verse.toString(),style: TextStyle(color: Theme.of(context).textTheme.caption?.color,fontSize: 12),),
                      Expanded(
                        child: GestureDetector(
                          onTap: (){
                            _showHighlightDialog(context:context,verse:verse,books: widget.books);
                          },
                          child: Html(
                            data:verse.text??'',
                            tagsList: Html.tags..addAll(['pb','t','j']),
                            style:{
                              '*':Style(
                                fontSize: FontSize(ref.watch(fontSizeProvider)),
                                margin: const EdgeInsets.symmetric(vertical: 2),
                                backgroundColor: highlightedVerse.colorIndex!=null?Colors.accents[highlightedVerse.colorIndex!].withOpacity(0.12):null
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
                      ),
                    ],
                  ),
                  if(commentary.text!=null&&ref.watch(showReferencesProvider)) Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.04),
                          borderRadius: BorderRadius.circular(3)
                      ),
                      child: Html(
                        data: commentary.text??'',
                        onLinkTap: (url, _, __, ___) {
                          VerseViewerDialog.showVerseDialog(url??'', context);
                        },
                        style:{
                          '*':Style(
                            fontSize: FontSize(ref.watch(fontSizeProvider)-2),
                            margin: const EdgeInsets.symmetric(vertical: 2),
                          ),
                        },
                      ),
                    ),
                  )
                ],
              ),
            );

        },
      ),
    );
  }

  void _showHighlightDialog({required BuildContext context,required BibleVersesModel verse, required List<BibleNamesModel> books}) {
    showModal(
        context: context,
        configuration: const FadeScaleTransitionConfiguration(
            barrierColor: Colors.transparent,
            barrierDismissible: true),
        builder: (BuildContext context) {
          return Consumer(
              builder: (context, ref,child) {
                final currentBook = books.firstWhere((element) => element.bookNumber==verse.bookNumber);
                final highlights = ref.watch(bookmarksStateProvider);
                final highlightedVerse = highlights.firstWhere((element) => element.text==verse.text,orElse: ()=>BibleVersesModel());
                return Align(
                    alignment: Alignment.centerLeft,
                    child: Card(
                      margin: const EdgeInsets.symmetric(horizontal: 9),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: verse.text!+'-${currentBook.longName} ${verse.chapter}:${verse.verse}'));
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Verse copied to clipboard"),));
                            },
                            dense: true,
                            leading: Icon(Icons.copy,color: Theme.of(context).colorScheme.secondary),
                            trailing: Icon(Icons.chevron_right,color: Theme.of(context).colorScheme.secondary),
                            title: Text("Copy Verse",style: TextStyle(fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.secondary),),
                          ),
                          const Divider(height: 0),
                          ListTile(
                            onTap: () {
                              final RenderBox renderBox = context.findRenderObject() as RenderBox;
                              Navigator.pop(context);
                              Share.share(verse.text!+'-${currentBook.longName} ${verse.chapter}:${verse.verse}',subject:"Share Verse",sharePositionOrigin: renderBox.localToGlobal(Offset.zero)&renderBox.size);
                            },
                            dense: true,
                            leading: Icon(Icons.share_rounded,color: Theme.of(context).colorScheme.secondary),
                            trailing: Icon(Icons.chevron_right,color: Theme.of(context).colorScheme.secondary),
                            title: Text("Share Verse",style: TextStyle(fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.secondary),),
                          ),
                          SizedBox(
                            height: 40,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: Colors.accents.length,
                                itemBuilder: (context,index){
                                  final color = Colors.accents[index];
                                  if (index==0){
                                    return GestureDetector(
                                      onTap: (){
                                        if(highlightedVerse.verse!=null){
                                          ref.read(bookmarksStateProvider.notifier).removeBookmark(verse: highlightedVerse);
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: Container(
                                        width: 50,
                                        margin: const EdgeInsets.symmetric(horizontal: 1,vertical: 1),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(3),
                                            border: highlightedVerse.verse==null?Border.all():null
                                        ),
                                      ),
                                    );
                                  }
                                  return GestureDetector(
                                    onTap: (){
                                      if(highlightedVerse.verse!=null&&highlightedVerse.colorIndex==index){
                                        ref.read(bookmarksStateProvider.notifier).removeBookmark(verse: highlightedVerse);
                                        Navigator.pop(context);
                                        return;
                                      }
                                      if(highlightedVerse.verse!=null&&highlightedVerse.colorIndex!=index){
                                        ref.read(bookmarksStateProvider.notifier).removeBookmark(verse: highlightedVerse);
                                        ref.read(bookmarksStateProvider.notifier).addBookmark(verse: verse.copyWith(colorIndex: index));
                                        Navigator.pop(context);
                                        return;
                                      }
                                      else{
                                        ref.read(bookmarksStateProvider.notifier).addBookmark(verse: verse.copyWith(colorIndex: index));
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Container(
                                      width: 50,
                                      margin: const EdgeInsets.symmetric(horizontal: 1,vertical: 1),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        border: highlightedVerse.verse!=null&&highlightedVerse.colorIndex==index?Border.all():null,
                                        // color: color,
                                      ),
                                      child: Stack(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.all(1),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(3),
                                                color: color
                                            ),),
                                          if(highlightedVerse.verse!=null&&highlightedVerse.colorIndex==index) const Center(child: Icon(Icons.close,color: Colors.white70))
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ));
              }
          );
        });
  }
}
