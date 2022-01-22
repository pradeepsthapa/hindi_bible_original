import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindi_bible/logics/storage_provider.dart';
import 'package:hindi_bible/model/bible_verses_model.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'bible_state_controller.dart';
import 'highlights_state_controller.dart';
import 'interstitial_ad_service.dart';


final bibleStateProvider = StateNotifierProvider.autoDispose<BibleStateController,BibleState>((ref) => BibleStateController(),);
final boxStorageNotifier = ChangeNotifierProvider<BookStorage>((ref)=>BookStorage(ref.read)..initializeBook());
final bookIndexProvider = StateProvider<int>((ref)=> 10);
final chapterNumberProvider = StateProvider<int>((ref)=> 1);
final currentVerseProvider = StateProvider<int>((ref)=> 0);

final fontSizeProvider = StateProvider<double>((ref)=>18.0);
final globalFontProvider = StateProvider<int>((ref)=>0);

final appColorProvider = StateProvider<int>((ref)=>15);
final showReferencesProvider = StateProvider<bool>((ref)=>true);

final scrollController = StateProvider<ItemScrollController>((ref)=>ItemScrollController());
final pageControllerProvider = Provider<PageController>((ref)=>PageController(initialPage: ref.read(chapterNumberProvider)-1));

final bookmarksStateProvider = StateNotifierProvider<BookmarksState,List<BibleVersesModel>>((ref)=>BookmarksState()..getBookmarks());
final interstitialAdProvider = Provider<InterstitialAdService>((ref)=>InterstitialAdService());