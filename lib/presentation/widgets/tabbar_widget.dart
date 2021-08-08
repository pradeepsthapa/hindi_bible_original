import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindi_bible/logics/providers.dart';
import 'package:hindi_bible/model/bible_model.dart';

class TabControllerWidget extends StatefulWidget {
  final List<Biblebook> biblebook;
  TabControllerWidget(this.biblebook);

  @override
  _TabControllerWidgetState createState() => _TabControllerWidgetState();
}

class _TabControllerWidgetState extends State<TabControllerWidget> with SingleTickerProviderStateMixin{

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Material(
      elevation: 5,
      shadowColor: Colors.black38,
      color: Theme.of(context).cardColor,
      child: DefaultTabController(
        length: 3,
        child: Wrap(
          children: [
            Container(
              color: Theme.of(context).primaryColor,
              child: TabBar(
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  controller: _tabController,
                  indicatorColor: Theme.of(context).primaryColor,
                  tabs: [
                    Tab(text: "BOOKS",),
                    Tab(text: "CHAPTER",),
                    Tab(text: "VERSE",),
                  ]),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 5),
              height: size.height *.5,
              child: TabBarView(
                controller: _tabController,
                children: [
                  GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 16/5,
                      crossAxisCount: 2),
                  children: widget.biblebook.map((e) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 7,vertical: 7),
                      decoration: BoxDecoration(
                        color: isDark?Colors.white12:Colors.black12,
                        borderRadius: BorderRadius.circular(3)
                      ),
                      child: TextButton(
                        onPressed: () {
                          context.read(boxStorageProvider).saveBookIndex(widget.biblebook.indexOf(e));
                          _tabController.animateTo(1,duration: Duration(milliseconds: 500),curve: Curves.linear);
                        },
                        child: Text(e.bname??'',style: TextStyle(),),),
                    );
                  }).toList(),),
                  //BOOK_LIST
                  Consumer(builder: (context,watch,child){
                    final List list = widget.biblebook[watch(bookIndexProvider).state].chapter;
                    final List<ChapterElement> chapters = list.map((e) => ChapterElement.fromJson(e)).toList();
                    return Wrap(
                      children: chapters.map((e) {
                        return TextButton(onPressed: (){
                          context.read(boxStorageProvider).saveChapterIndex(e.cnumber??'1');
                          context.read(pageController).animateToPage(int.parse(e.cnumber??'1')-1,duration: Duration(milliseconds: 400),curve: Curves.decelerate);
                          _tabController.animateTo(2,duration: Duration(milliseconds: 500),curve: Curves.linear);
                        }, child: Text(e.cnumber??''));
                      }).toList(),
                    );
                  }),
                  //CHAPTER_LIST
                  Consumer(
                    builder: (context,watch,child){
                      final List list = widget.biblebook[watch(bookIndexProvider).state].chapter;
                      final List<ChapterElement> chapters = list.map((e) => ChapterElement.fromJson(e)).toList();
                      return Align(
                        alignment: Alignment.topCenter,
                        child: Wrap(
                          children: chapters[int.parse(watch(chapterNumberProvider).state)-1].vers!.map((e) {
                            return GestureDetector(
                              onTap: (){
                                context.read(scrollController).state.scrollTo(index: chapters[int.parse(watch(chapterNumberProvider).state)-1].vers!.indexOf(e), duration: Duration(milliseconds: 400),curve: Curves.decelerate);
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 7,horizontal: 7),
                                child: CircleAvatar(child: Text(e.vnumber??'',style: TextStyle(color: isDark?Colors.white:Colors.black,fontSize: 15),),backgroundColor: isDark?Colors.white12:Colors.black.withOpacity(0.10),),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ],),
            ),
          ],
        ),
      ),
    );
  }
}
