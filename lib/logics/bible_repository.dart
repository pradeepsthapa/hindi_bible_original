// import 'dart:convert';
// import 'package:hindi_bible/model/bible_model.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:hindi_bible/model/bible_model_sword.dart';
// import 'package:hindi_bible/model/details_model_sword.dart';
//
// class BibleRepository {
//   // static Future<BibleModel> getBible() async{
//   //   final String response = await rootBundle.loadString('assets/hindi_bible.json');
//   //   return BibleModel.fromJson(json.decode(response));
//   // }
//
//
//   static Future<List<BibleModel>> getBible()async{
//     final String response = await rootBundle.loadString('assets/bible/bible.json');
//     return bibleModelFromJson(response);
//   }
//
//   static Future<List<DetailsModel>> getDetails()async{
//     final String response = await rootBundle.loadString('assets/bible/Details.json');
//     return detailsModelFromJson(response);
//   }
// }