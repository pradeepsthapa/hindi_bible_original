import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindi_bible/logics/bible_state_controller.dart';
import 'package:hindi_bible/logics/providers.dart';
import 'package:hindi_bible/presentation/widgets/native_widget.dart';

class BookmarkScreen extends ConsumerWidget {
  const BookmarkScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {

    final bookmarks = ref.watch(bookmarksStateProvider);

    final state = ref.watch(bibleStateProvider);
    if(state is BibleLoaded){
      return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: AppBar(
              title: const Text("Highlighted Verses"),
            )),
        body: bookmarks.isEmpty?Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/empty.gif',fit: BoxFit.cover),
            const SizedBox(height: 10),
            Text("No highlighted verse",style: TextStyle(color: Colors.grey[500],fontSize: 24),textAlign: TextAlign.center),
          ],
        ),):ListView.builder(
            itemCount: bookmarks.length,
            itemBuilder: (context,index){
              final verse = bookmarks[index];
              final currentBook = state.bibleBooks.firstWhere((element) => element.bookNumber==verse.bookNumber);
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 3),
                decoration: BoxDecoration(
                    color: Colors.accents[verse.colorIndex??0].withOpacity(0.12),
                    borderRadius: BorderRadius.circular(7)
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Padding(
                    padding: const EdgeInsets.only(top: 15,left: 9),
                    child: CircleAvatar(backgroundColor: Colors.accents[verse.colorIndex!].withOpacity(0.5),),
                  ),
                  title: Html(
                    data:verse.text??'',
                    tagsList: Html.tags..addAll(['pb','t','j']),
                    style:{
                      '*':Style(
                        fontSize: FontSize(ref.watch(fontSizeProvider)-2),
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
                  subtitle: Text('${currentBook.longName} ${verse.chapter}:${verse.verse}'),
                  trailing: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: IconButton(
                      onPressed: (){
                        ref.read(bookmarksStateProvider.notifier).removeBookmark(verse: verse);
                      },
                      icon: Icon(Icons.delete,color: Colors.red.withOpacity(0.5)),
                    ),
                  ),
                ),
              );
            }),
        bottomNavigationBar: const NativeBannerAdWidget(),
      );
    }
    return const SizedBox.shrink();
  }
}
