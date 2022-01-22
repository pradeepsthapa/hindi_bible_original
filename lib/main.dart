import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hindi_bible/presentation/screens/bible/bible_loaded_screen.dart';
import 'package:wakelock/wakelock.dart';
import 'constants/constants.dart';
import 'logics/bible_state_controller.dart';
import 'logics/providers.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Wakelock.enable();
  FacebookAudienceNetwork.init();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(context, ref) {
    final font = ref.watch(globalFontProvider);
    final globalFont = Constants.globalFonts[font];
    return MaterialApp(
      title: "Pavitra Bible",
      themeMode: ref.watch(boxStorageNotifier).darkMode?ThemeMode.dark:ThemeMode.light,
      darkTheme: ThemeData.dark().copyWith(
          primaryTextTheme: globalFont.textTheme.copyWith(
            headline6: TextStyle(color: Colors.white,fontFamily: globalFont.fontFamily),
            bodyText1: TextStyle(color: Colors.white,fontFamily: globalFont.fontFamily),
          ),
          textTheme: globalFont.textTheme.copyWith(
            overline: TextStyle(color: Colors.white,fontFamily: globalFont.fontFamily),
            bodyText2: TextStyle(color: Colors.white,fontFamily: globalFont.fontFamily),
            bodyText1: TextStyle(color: Colors.white,fontFamily: globalFont.fontFamily),
            subtitle1:  TextStyle(color: Colors.white,fontFamily: globalFont.fontFamily),
            caption:const TextStyle(color: Colors.white70),
          ),
          pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: SharedAxisPageTransitionsBuilder(
                  transitionType: SharedAxisTransitionType.scaled,
                ),
              }
          )
      ),
      theme: ThemeData(
          primarySwatch: Colors.indigo,
          // primarySwatch: Colors.primaries[ref.watch(appColorProvider)],
          fontFamily: globalFont.fontFamily,
          textTheme: globalFont.textTheme,
          pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: SharedAxisPageTransitionsBuilder(
                  transitionType: SharedAxisTransitionType.scaled,
                ),
              }
          )
      ),
      home: const HomePage(),
    );
  }
}


class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      ref.read(boxStorageNotifier).loadBookIndex();
      ref.read(bibleStateProvider.notifier).getBible();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bibleStateProvider);
    if(state is BibleLoading) {
      return const Center(child: CircularProgressIndicator(),);
    }
    if(state is BibleLoaded){
      return WillPopScope(onWillPop: () async{
        ref.read(interstitialAdProvider).showExitAd();
        return false;
      },
      child: BibleLoadedScreen(bibleState: state));
    }
    if(state is BibleError){
      return Center(child: Text(state.message),);
    }
    return const SizedBox.shrink();
  }
}

