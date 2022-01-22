import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hindi_bible/constants/constants.dart';
import 'package:hindi_bible/logics/providers.dart';

class BookStorage extends ChangeNotifier{
  final Reader _reader;
  BookStorage(this._reader);

  bool _darkMode = false;
  bool get darkMode => _darkMode;

  final _box = GetStorage();

  initializeBook(){
    _box.writeIfNull(Constants.bibleIndex, 10);
    _box.writeIfNull(Constants.bibleChapter, 1);
    _box.writeIfNull(Constants.darkMode, false);
    _box.writeIfNull(Constants.fontSize, 18.0);
    _box.writeIfNull(Constants.fontIndex, 0);
    _box.writeIfNull(Constants.backgroundColor, 15);
    _box.writeIfNull(Constants.showReferences, true);
    _box.writeIfNull(Constants.bookmarks, <Map<String,dynamic>>[]);
    initialDarkMode();
  }

  void initialDarkMode(){
    _darkMode = _box.read(Constants.darkMode);
    notifyListeners();
  }

  void loadBookIndex(){
    _reader(bookIndexProvider.state).state = _box.read(Constants.bibleIndex);
    _reader(chapterNumberProvider.state).state = _box.read(Constants.bibleChapter);
    _reader(fontSizeProvider.state).state = _box.read(Constants.fontSize);
    _reader(globalFontProvider.state).state = _box.read(Constants.fontIndex);
    _reader(appColorProvider.state).state =  _box.read(Constants.backgroundColor);
    _reader(showReferencesProvider.state).state =  _box.read(Constants.showReferences);
  }

  ThemeMode getThemeMode() =>darkMode?ThemeMode.dark:ThemeMode.light;

  void changeDarkTheme(bool value){
    _box.write(Constants.darkMode, value);
    _darkMode = value;
    notifyListeners();
  }

  void saveFontSize(double size){
    _box.write(Constants.fontSize, size);
  }

  void saveFontStyle(int index){
    _box.write(Constants.fontIndex, index);
    _reader(globalFontProvider.state).state = index;
  }

  void saveBackground(int color){
    _box.write(Constants.backgroundColor, color);
    _reader(appColorProvider.state).state = color;
  }

  void saveBookIndex(int index){
    _box.write(Constants.bibleIndex, index);
    _reader(bookIndexProvider.state).state = index;
  }

  void saveChapterIndex(int pageIndex){
    _box.write(Constants.bibleChapter, pageIndex);
    _reader(chapterNumberProvider.state).state = pageIndex;
  }

  void showHideReferences(bool value){
    _box.write(Constants.showReferences, value);
    _reader(showReferencesProvider.state).state = value;
  }
}