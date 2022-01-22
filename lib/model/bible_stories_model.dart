import 'dart:convert';

List<BibleStoriesModel> bibleStoriesModelFromJson(String str) => List<BibleStoriesModel>.from(json.decode(str).map((x) => BibleStoriesModel.fromJson(x)));
String bibleStoriesModelToJson(List<BibleStoriesModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BibleStoriesModel {
  BibleStoriesModel({
    this.bookNumber,
    this.chapter,
    this.orderIfSeveral,
    this.title,
    this.verse,
  });

  int? bookNumber;
  int? chapter;
  int? orderIfSeveral;
  String? title;
  int? verse;

  factory BibleStoriesModel.fromJson(Map<String, dynamic> json) => BibleStoriesModel(
    bookNumber: json["book_number"],
    chapter: json["chapter"],
    orderIfSeveral: json["order_if_several"],
    title: json["title"],
    verse: json["verse"],
  );

  Map<String, dynamic> toJson() => {
    "book_number": bookNumber,
    "chapter": chapter,
    "order_if_several": orderIfSeveral,
    "title": title,
    "verse": verse,
  };
}
