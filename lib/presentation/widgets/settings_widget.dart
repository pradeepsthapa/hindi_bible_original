import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindi_bible/constants/constants.dart';
import 'package:hindi_bible/logics/providers.dart';
import 'slider_widget.dart';

class SettingsWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Align(
        alignment: Alignment.topCenter,
        child: Material(
          elevation: 5,
          shadowColor: Colors.black54,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Wrap(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MaterialBanner(
                        backgroundColor: Theme.of(context).accentColor.withOpacity(0.1),
                        content: Center(child: Text("Settings",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18, color: Theme.of(context).accentColor),)), actions: [Container()]),
                    settingsHeader(context,"Font Size"),
                    FontSliderWidget(),
                    ExpansionTile(
                      initiallyExpanded: true,
                      leading: Icon(Icons.palette_rounded),
                      title: Text("Background",style: TextStyle(),),
                      children: [
                        Consumer(
                          builder: (context,watch, child) {
                            return Container(
                              height: 53,
                              child: ListView(
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                  children: Constants.backgroundColors.map((e) =>
                                      InkWell(
                                        borderRadius: BorderRadius.circular(5),
                                        splashFactory: InkRipple.splashFactory,
                                        onTap: (){
                                          final color = e.value.toRadixString(16);
                                          context.read(boxStorageProvider).saveBackground(color);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(1),
                                          margin: EdgeInsets.symmetric(vertical: 5,horizontal: 3),
                                          decoration:BoxDecoration(
                                              border: watch(colorProvider).state == e.value.toRadixString(16) ?Border.all(width: 2,color: isDark?Colors.white:Colors.black):null,
                                          ),
                                          child: Container(width: 60,color: e,),),
                                      )).toList()),
                            );
                          }
                        )],
                    )

                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget settingsHeader(BuildContext context,String text){
  return Padding(
    padding: const EdgeInsets.fromLTRB(24, 7, 0, 0),
    child: Text(text,style: TextStyle(fontSize: 17,color: Theme.of(context).accentColor),),
  );
}