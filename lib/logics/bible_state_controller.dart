import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindi_bible/model/bible_commentaries_model.dart';
import 'package:hindi_bible/model/bible_names_model.dart';
import 'package:hindi_bible/model/bible_stories_model.dart';
import 'package:hindi_bible/model/bible_verses_model.dart';

abstract class BibleState{
  const BibleState();
}

class BibleLoading extends BibleState{
  const BibleLoading();
}

class BibleLoaded extends BibleState{
  final List<BibleNamesModel> bibleBooks;
  final List<BibleVersesModel> loadedBible;
  final List<BibleCommentaryModel> loadedCommentary;
  final List<BibleStoriesModel> bibleStories;
  const BibleLoaded({required this.bibleBooks, required this.loadedBible, required this.loadedCommentary, required this.bibleStories});

}

class BibleError extends BibleState{
  final String message;
  const BibleError({required this.message});
}

class BibleStateController extends StateNotifier<BibleState>{
  BibleStateController() : super(const BibleLoading());

  Future<void> getBible()async{
    try {
      final String bibleNamesResponse = await rootBundle.loadString('assets/json/books.json');
      final String bibleStoriesResponse = await rootBundle.loadString('assets/json/stories.json');
      final String bibleVersesResponse = await rootBundle.loadString('assets/json/verses.json');
      final String bibleCommentaryResponse = await rootBundle.loadString('assets/json/commentaries.json');
      state = BibleLoaded(
        bibleBooks: bibleNamesModelFromJson(bibleNamesResponse),
        bibleStories: bibleStoriesModelFromJson(bibleStoriesResponse),
        loadedBible: bibleVersesModelFromJson(bibleVersesResponse),
        loadedCommentary: bibleCommentaryModelFromJson(bibleCommentaryResponse),
      );
    } catch (e) {
      state = BibleError(message: e.toString());
    }
  }
}