import 'dart:convert';

List<BibleCommentaryModel> bibleCommentaryModelFromJson(String str) => List<BibleCommentaryModel>.from(json.decode(str).map((x) => BibleCommentaryModel.fromJson(x)));
String bibleCommentaryModelToJson(List<BibleCommentaryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BibleCommentaryModel {
  BibleCommentaryModel({
    this.bookNumber,
    this.chapterNumberFrom,
    this.chapterNumberTo,
    this.marker,
    this.text,
    this.verseNumberFrom,
    this.verseNumberTo,
  });

  int? bookNumber;
  int? chapterNumberFrom;
  dynamic chapterNumberTo;
  Marker? marker;
  String? text;
  int? verseNumberFrom;
  dynamic verseNumberTo;

  factory BibleCommentaryModel.fromJson(Map<String, dynamic> json) => BibleCommentaryModel(
    bookNumber: json["book_number"],
    chapterNumberFrom: json["chapter_number_from"],
    chapterNumberTo: json["chapter_number_to"],
    marker: markerValues.map[json["marker"]],
    text: json["text"],
    verseNumberFrom: json["verse_number_from"],
    verseNumberTo: json["verse_number_to"],
  );

  Map<String, dynamic> toJson() => {
    "book_number": bookNumber,
    "chapter_number_from": chapterNumberFrom,
    "chapter_number_to": chapterNumberTo,
    "marker": markerValues.reverse?[marker],
    "text": text,
    "verse_number_from": verseNumberFrom,
    "verse_number_to": verseNumberTo,
  };
}

enum Marker { the_1, the_2, the_3, the_4, the_5, the_6, the_7, the_8, the_9, marker, purple, fluffy, tentacled, sticky, indigo, indecent, hilarious, ambitious, cunning, magenta, frisky, mischievous, braggadocious, the_10, the_11, the_12, the_13, the_14, the_15, marker_9, the_16, the_17, the_18, the_19, marker_10, marker_11, marker_12, marker_13, marker_14, marker_15, marker_16, marker_17,empty }

final markerValues = EnumValues({
  "ⓙ": Marker.ambitious,
  "ⓞ": Marker.braggadocious,
  "ⓚ": Marker.cunning,
  "ⓐ": Marker.empty,
  "ⓓ": Marker.fluffy,
  "ⓜ": Marker.frisky,
  "ⓘ": Marker.hilarious,
  "ⓗ": Marker.indecent,
  "ⓖ": Marker.indigo,
  "ⓛ": Marker.magenta,
  "ⓑ": Marker.marker,
  "[10]": Marker.marker_10,
  "[11]": Marker.marker_11,
  "[12]": Marker.marker_12,
  "[13]": Marker.marker_13,
  "[14]": Marker.marker_14,
  "[15]": Marker.marker_15,
  "[16]": Marker.marker_16,
  "[17]": Marker.marker_17,
  "[9]": Marker.marker_9,
  "ⓝ": Marker.mischievous,
  "ⓒ": Marker.purple,
  "ⓕ": Marker.sticky,
  "ⓔ": Marker.tentacled,
  "[1]": Marker.the_1,
  "ⓠ": Marker.the_10,
  "ⓡ": Marker.the_11,
  "ⓢ": Marker.the_12,
  "ⓣ": Marker.the_13,
  "ⓤ": Marker.the_14,
  "ⓥ": Marker.the_15,
  "ⓦ": Marker.the_16,
  "ⓧ": Marker.the_17,
  "ⓨ": Marker.the_18,
  "ⓩ": Marker.the_19,
  "[2]": Marker.the_2,
  "[3]": Marker.the_3,
  "[4]": Marker.the_4,
  "[5]": Marker.the_5,
  "[6]": Marker.the_6,
  "[7]": Marker.the_7,
  "[8]": Marker.the_8,
  "ⓟ": Marker.the_9
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    reverseMap ??= map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
