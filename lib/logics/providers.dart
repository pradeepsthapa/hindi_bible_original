import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindi_bible/logics/bible_repository.dart';
import 'package:hindi_bible/model/bible_model.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'storage_provider.dart';

final bookRepositoryProvider = FutureProvider<BibleModel>((ref)=>BibleRepository.getBible());

final boxStorageProvider = Provider<StorageProvider>((ref)=>StorageProvider(ref.read)..initStorage());

final bookIndexProvider = StateProvider<int>((ref)=> 0);
final chapterNumberProvider = StateProvider<String>((ref)=>'1');

final darkModeProvider = StateProvider<bool>((ref)=>false);
final fontSizeProvider = StateProvider<double>((ref)=>17.0);
final colorProvider = StateProvider<String>((ref)=>'0');

final pageController = Provider<PageController>((ref)=>PageController(initialPage: int.parse(ref.read(chapterNumberProvider).state)-1));
final scrollController = StateProvider<ItemScrollController>((ref)=>ItemScrollController());

