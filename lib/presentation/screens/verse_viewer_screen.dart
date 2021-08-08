import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindi_bible/logics/providers.dart';
import 'package:hindi_bible/model/bible_model.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class VerseViewerScreen extends StatefulWidget {
  final List<Ver> verses;
  VerseViewerScreen(this.verses);


  @override
  _VerseViewerScreenState createState() => _VerseViewerScreenState();
}

class _VerseViewerScreenState extends State<VerseViewerScreen> {


  late final ItemScrollController itemScrollController;
  late final ItemPositionsListener itemPositionsListener;

  @override
  void initState() {
    super.initState();
      itemScrollController = ItemScrollController();
    itemPositionsListener = ItemPositionsListener.create();

    SchedulerBinding.instance!.addPostFrameCallback((_) {
      context.read(scrollController).state = itemScrollController;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        return ScrollablePositionedList.builder(
          itemScrollController: itemScrollController,
          itemPositionsListener: itemPositionsListener,
          itemCount: widget.verses.length,
          itemBuilder: (BuildContext context, int index) {

            final item = widget.verses[index];
            return InkWell(
              onTap: (){
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 7),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.vnumber??''),
                    SizedBox(width: 5,),
                    Expanded(child: Text(item.text??'',
                      style: TextStyle(fontSize: watch(fontSizeProvider).state),
                    )),
                  ],
                ),
              ),
            );
          },
        );
      }
    );
  }
}
