import 'dart:convert';

BibleModel bibleModelFromJson(String str) => BibleModel.fromJson(json.decode(str));

String bibleModelToJson(BibleModel data) => json.encode(data.toJson());

class BibleModel {
  BibleModel({
    this.comment,
    this.comment1,
    this.comment2,
    this.comment3,
    this.comment4,
    this.comment5,
    this.comment6,
    this.xmlbible,
    this.standalone,
  });

  String? comment;
  String? comment1;
  String? comment2;
  String? comment3;
  String? comment4;
  String? comment5;
  String? comment6;
  Xmlbible? xmlbible;
  String? standalone;

  factory BibleModel.fromJson(Map<String, dynamic> json) => BibleModel(
    comment: json["#comment"],
    comment1: json["#comment1"],
    comment2: json["#comment2"],
    comment3: json["#comment3"],
    comment4: json["#comment4"],
    comment5: json["#comment5"],
    comment6: json["#comment6"],
    xmlbible: Xmlbible.fromJson(json["XMLBIBLE"]),
    standalone: json["#standalone"],
  );

  Map<String, dynamic> toJson() => {
    "#comment": comment,
    "#comment1": comment1,
    "#comment2": comment2,
    "#comment3": comment3,
    "#comment4": comment4,
    "#comment5": comment5,
    "#comment6": comment6,
    "XMLBIBLE": xmlbible?.toJson(),
    "#standalone": standalone,
  };
}

class Xmlbible {
  Xmlbible({
    this.version,
    this.p1NoNamespaceSchemaLocation,
    this.biblename,
    this.type,
    this.status,
    this.revision,
    this.xmlnsP1,
    this.information,
    this.biblebook,
  });

  String? version;
  String? p1NoNamespaceSchemaLocation;
  String? biblename;
  String? type;
  String? status;
  String? revision;
  String? xmlnsP1;
  Information? information;
  List<Biblebook>? biblebook;

  factory Xmlbible.fromJson(Map<String, dynamic> json) => Xmlbible(
    version: json["-version"],
    p1NoNamespaceSchemaLocation: json["-p1:noNamespaceSchemaLocation"],
    biblename: json["-biblename"],
    type: json["-type"],
    status: json["-status"],
    revision: json["-revision"],
    xmlnsP1: json["-xmlns:p1"],
    information: Information.fromJson(json["INFORMATION"]),
    biblebook: List<Biblebook>.from(json["BIBLEBOOK"].map((x) => Biblebook.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "-version": version,
    "-p1:noNamespaceSchemaLocation": p1NoNamespaceSchemaLocation,
    "-biblename": biblename,
    "-type": type,
    "-status": status,
    "-revision": revision,
    "-xmlns:p1": xmlnsP1,
    "INFORMATION": information?.toJson(),
    "BIBLEBOOK": List<dynamic>.from(biblebook!.map((x) => x.toJson())),
  };
}

class Biblebook {
  Biblebook({
    this.bnumber,
    this.bname,
    this.bsname,
    this.chapter,
  });

  String? bnumber;
  String? bname;
  String? bsname;
  dynamic chapter;

  factory Biblebook.fromJson(Map<String, dynamic> json) => Biblebook(
    bnumber: json["-bnumber"],
    bname: json["-bname"],
    bsname: json["-bsname"],
    chapter: json["CHAPTER"],
  );

  Map<String, dynamic> toJson() => {
    "-bnumber": bnumber,
    "-bname": bname,
    "-bsname": bsname,
    "CHAPTER": chapter,
  };
}

class ChapterElement {
  ChapterElement({
    this.cnumber,
    this.vers,
  });

  String? cnumber;
  List<Ver>? vers;

  factory ChapterElement.fromJson(Map<String, dynamic> json) => ChapterElement(
    cnumber: json["-cnumber"],
    vers: List<Ver>.from(json["VERS"].map((x) => Ver.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "-cnumber": cnumber,
    "VERS": List<dynamic>.from(vers!.map((x) => x.toJson())),
  };
}

class Ver {
  Ver({
    this.vnumber,
    this.text,
  });

  String? vnumber;
  String? text;

  factory Ver.fromJson(Map<String, dynamic> json) => Ver(
    vnumber: json["-vnumber"],
    text: json["#text"],
  );

  Map<String, dynamic> toJson() => {
    "-vnumber": vnumber,
    "#text": text,
  };
}

class Information {
  Information({
    this.title,
    this.creator,
    this.subject,
    this.description,
    this.publisher,
    this.contributors,
    this.date,
    this.type,
    this.format,
    this.identifier,
    this.source,
    this.language,
    this.coverage,
    this.rights,
  });

  String? title;
  String? creator;
  Contributors? subject;
  String? description;
  Contributors? publisher;
  Contributors? contributors;
  DateTime? date;
  Contributors? type;
  String? format;
  String? identifier;
  String? source;
  String? language;
  String? coverage;
  String? rights;

  factory Information.fromJson(Map<String, dynamic> json) => Information(
    title: json["title"],
    creator: json["creator"],
    subject: Contributors.fromJson(json["subject"]),
    description: json["description"],
    publisher: Contributors.fromJson(json["publisher"]),
    contributors: Contributors.fromJson(json["contributors"]),
    date: DateTime.parse(json["date"]),
    type: Contributors.fromJson(json["type"]),
    format: json["format"],
    identifier: json["identifier"],
    source: json["source"],
    language: json["language"],
    coverage: json["coverage"],
    rights: json["rights"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "creator": creator,
    "subject": subject?.toJson(),
    "description": description,
    "publisher": publisher?.toJson(),
    "contributors": contributors?.toJson(),
    "date": "${date?.year.toString().padLeft(4, '0')}-${date?.month.toString().padLeft(2, '0')}-${date?.day.toString().padLeft(2, '0')}",
    "type": type?.toJson(),
    "format": format,
    "identifier": identifier,
    "source": source,
    "language": language,
    "coverage": coverage,
    "rights": rights,
  };
}

class Contributors {
  Contributors({
    this.selfClosing,
  });

  String? selfClosing;

  factory Contributors.fromJson(Map<String, dynamic> json) => Contributors(
    selfClosing: json["-self-closing"],
  );

  Map<String, dynamic> toJson() => {
    "-self-closing": selfClosing,
  };
}
