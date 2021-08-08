import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindi_bible/logics/providers.dart';
import 'package:hindi_bible/model/bible_model.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class MainDrawer extends StatelessWidget {
  final Information information;
  MainDrawer(this.information);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/images/drawer.jpg'),fit: BoxFit.cover)
            ),
              accountName: Text(information.title??''),
              accountEmail: Text('pradeepsthapa@gmail.com',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 12,color: Colors.grey[600]),)),
          ListTile(
            dense: true,
            leading:Icon(CupertinoIcons.sun_min),
            title: Text("Dark Mode"),
            trailing:Consumer(
                builder: (context,watch, child) {
                  return Switch(
                    value: watch(darkModeProvider).state,
                    onChanged: (bool value) {
                      context.read(boxStorageProvider).saveDarkMode(value);
                    },);
                }
            ),

          ),

          ListTile(
            dense: true,
            leading: Icon(CupertinoIcons.rectangle_grid_2x2),
            title: Text("More Apps"),
            onTap: ()async{
              const url = 'https://play.google.com/store/apps/developer?id=pTech';
              if(await canLaunch(url)){
                await launch(url);
              }
              else{
                throw 'Could not launch $url';
              }
            },
          ),
          ListTile(
            dense: true,
            leading: Icon(CupertinoIcons.info_circle),
            title: Text("About"),
            onTap: (){
              showModal(
                  configuration: FadeScaleTransitionConfiguration(
                      transitionDuration: Duration(milliseconds: 400),
                      barrierColor: Colors.transparent,
                      barrierDismissible: true),
                  context: context,
                  builder: (BuildContext ctx){
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 7),
                      child: Center(
                        child: Material(
                          elevation: 3,
                          shadowColor: Colors.black38,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          child: Container(
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(information.title??'',style: TextStyle(color: Theme.of(context).accentColor,fontSize: 18,fontWeight: FontWeight.w500),),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(information.description??'',style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w400),),
                                ),
                                Align(
                                    alignment: Alignment.bottomRight,
                                    child: TextButton(onPressed: ()=>Navigator.pop(context), child: Text("Close")))
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            },
          ),

          ListTile(leading: Icon(CupertinoIcons.square_arrow_up),
            dense: true,
            title: Text("Share App"),
            onTap: (){
              final String text = 'https://play.google.com/store/apps/details?id=com.ccbc.hindi_bible.hindi_bible';
              final RenderBox renderBox = context.findRenderObject() as RenderBox;
              Share.share(text,sharePositionOrigin: renderBox.localToGlobal(Offset.zero)&renderBox.size);
            },
          ),
          ListTile(leading: Icon(CupertinoIcons.xmark_square),
            dense: true,
            title: Text("Exit"),
            onTap: ()=>SystemNavigator.pop(),
          ),
        ],
      ),
    );
  }
}
