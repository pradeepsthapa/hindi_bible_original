import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hindi_bible/constants/constants.dart';
import 'package:hindi_bible/logics/providers.dart';

class StorageProvider{
  final Reader _reader;
  StorageProvider(this._reader);

  final _box = GetStorage();


  void saveDarkMode (bool value){
    _box.write(Constants.DARK_MODE, value);
    _reader(darkModeProvider).state = value;
  }

  void saveFontSize(double size){
    _box.write(Constants.FONT_SIZE, size);
  }

  void saveBackground(String color){
    _box.write(Constants.BACKGROUND_COLOR, color);
    _reader(colorProvider).state = color;
  }

  void saveBookIndex(int index){
    _box.write(Constants.BOOK_INDEX, index);
    _reader(bookIndexProvider).state = index;
  }

  void saveChapterIndex(String name){
    _box.write(Constants.CHAPTER_INDEX, name);
    _reader(chapterNumberProvider).state = name;
  }


  void initStorage(){
    _box.writeIfNull(Constants.DARK_MODE, false);
    _box.writeIfNull(Constants.BOOK_INDEX, 0);
    _box.writeIfNull(Constants.CHAPTER_INDEX, '1');
    _box.writeIfNull(Constants.FONT_SIZE, 17.0);
    _box.writeIfNull(Constants.BACKGROUND_COLOR, '0');
  }

  void loadInitials() async {
    final dark = await _box.read(Constants.DARK_MODE);
    final bookIndex = await _box.read(Constants.BOOK_INDEX);
     final chapterIndex= await _box.read(Constants.CHAPTER_INDEX);
    final font = await _box.read(Constants.FONT_SIZE);
    final background = await _box.read(Constants.BACKGROUND_COLOR);

    _reader(darkModeProvider).state = dark;
    _reader(bookIndexProvider).state = bookIndex;
    _reader(chapterNumberProvider).state = chapterIndex;
    _reader(fontSizeProvider).state = font;
    _reader(colorProvider).state = background;
  }
}