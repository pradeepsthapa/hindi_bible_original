import 'dart:convert';
import 'package:hindi_bible/model/bible_model.dart';
import 'package:flutter/services.dart' show rootBundle;

class BibleRepository {
  static Future<BibleModel> getBible() async{
    final String response = await rootBundle.loadString('assets/hindi_bible.json');
    return BibleModel.fromJson(json.decode(response));
  }
}