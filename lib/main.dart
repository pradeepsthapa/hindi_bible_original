import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hindi_bible/presentation/widgets/banner_widget.dart';
import 'package:wakelock/wakelock.dart';
import 'logics/providers.dart';
import 'presentation/screens/book_loaded_screen.dart';

void main() async{
  await GetStorage.init();
  await Wakelock.enable();
  FacebookAudienceNetwork.init();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(context, watch) {
    return MaterialApp(
      title: 'Hindi Bible',
      themeMode: watch(darkModeProvider).state?ThemeMode.dark:ThemeMode.light,
      darkTheme:  ThemeData.dark().copyWith(
          textTheme: GoogleFonts.sourceSansProTextTheme().copyWith(
            bodyText2: TextStyle(color: Colors.white,fontFamily: GoogleFonts.sourceSansPro().fontFamily),
            bodyText1: TextStyle(color: Colors.white,fontFamily: GoogleFonts.sourceSansPro().fontFamily),
            subtitle1:  TextStyle(color: Colors.white,fontFamily: GoogleFonts.sourceSansPro().fontFamily),
            caption:TextStyle(color: Colors.white,),
          )
      ),
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        fontFamily: GoogleFonts.sourceSansPro().fontFamily,
        textTheme: GoogleFonts.sourceSansProTextTheme(),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      context.read(boxStorageProvider).loadInitials();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context,watch,child){
          return watch(bookRepositoryProvider).when(
              data: (data){
                return BookLoadedScreen(data.xmlbible?.biblebook??[],data.xmlbible!.information);
              },
              loading: ()=> Center(child: CircularProgressIndicator()),
              error: (err,st)=>Center(child: Text(err.toString())));
        },
      ),
      bottomNavigationBar: BannerWidget(),
    );
  }
}

