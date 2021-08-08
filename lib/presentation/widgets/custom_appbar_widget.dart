import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindi_bible/logics/providers.dart';
import 'package:hindi_bible/model/bible_model.dart';
import 'package:hindi_bible/presentation/widgets/settings_widget.dart';
import 'package:hindi_bible/presentation/widgets/tabbar_widget.dart';

class CustomAppBar extends StatelessWidget {
  final List<Biblebook> books;
  CustomAppBar(this.books);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppBar(
      backgroundColor: isDark?null:Colors.blueGrey.shade900,
      title: GestureDetector(
        onTap: (){
          showModal(
              configuration: FadeScaleTransitionConfiguration(
                transitionDuration: Duration(milliseconds: 400),
                barrierColor: Colors.transparent,
                barrierDismissible: true),
              context: context,
              builder: (BuildContext ctx){
                return Align(
                  alignment: Alignment.topCenter,
                  child: TabControllerWidget(books),
                );
              });
        },
        child: Consumer(
            builder: (context, watch, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 5),
                    decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 3),
                      child: Text(books[watch(bookIndexProvider).state].bname??"Genesis",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16)),
                    ),
                  ),
                  SizedBox(width: 7,),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7,vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 3),
                        child: Text("Chapter ${watch(chapterNumberProvider).state}",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16),),
                      )),
                ],
              );
            }
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: IconButton(onPressed: (){
            showModal(
                configuration: FadeScaleTransitionConfiguration(
                  transitionDuration: Duration(milliseconds: 350),
                  barrierColor: Colors.transparent,
                  barrierDismissible: true,
                ),
                context: context,
                builder: (_)=>SettingsWidget());
          }, icon: Icon(CupertinoIcons.textformat_size)),
        )
      ],
    );
  }
}
