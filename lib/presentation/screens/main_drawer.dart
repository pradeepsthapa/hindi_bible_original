import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Stack(
            children: [
              ColorFiltered(
                  colorFilter: ColorFilter.mode(Theme.of(context).primaryColor, BlendMode.overlay),
                  child: Image.asset('assets/images/drawer.jpg',fit: BoxFit.cover,height: 148,width: double.infinity,)),
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor.withOpacity(0.3),
                          Colors.black12,
                        ],begin: Alignment.topCenter,end: Alignment.bottomCenter
                    )
                ),
                height: 148,
              ),
              const Positioned(
                  bottom: 20,left: 20,
                  child: Text('Pavitra Bible - पवित्र बाइबिल (BSI)',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 15),))
            ],
          ),
          ListTile(
            dense: true,
            title: const Text("Share"),
            subtitle: const Text("Share this app with friends"),
            trailing: const Icon(Icons.chevron_right),
            onTap: ()async{
              const String text = 'https://play.google.com/store/apps/details?id=com.ccbc.niv_bible';
              final RenderBox renderBox = context.findRenderObject() as RenderBox;
              Share.share(text,sharePositionOrigin: renderBox.localToGlobal(Offset.zero)&renderBox.size);
            },
          ),
          const Divider(height: 0,thickness: 0.7),
          ListTile(
            dense: true,
            title: const Text("More Apps"),
            subtitle: const Text("Explore more similar Bible apps"),
            trailing: const Icon(Icons.chevron_right),
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
          const Divider(height: 0,thickness: 0.7),
          ListTile(
            dense: true,
            title: const Text("Privacy Policy"),
            trailing: const Icon(Icons.chevron_right),
            onTap: ()async{
              const url = 'https://pages.flycricket.io/hindi-holy-bible/privacy.html';
              if(await canLaunch(url)){
                await launch(url);
              }
              else{
                throw 'Could not launch $url';
              }
            },
          ),
          const Divider(height: 0,thickness: 0.7),
          ListTile(
            dense: true,
            title: const Text("Exit"),
            trailing: const Icon(Icons.chevron_right),
            onTap: (){
             SystemNavigator.pop();
            },
          ),
          const Divider(height: 0,thickness: 0.7),
        ],
      ),
    );
  }
}
