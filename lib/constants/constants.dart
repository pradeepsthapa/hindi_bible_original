import 'package:google_fonts/google_fonts.dart';
import 'package:hindi_bible/model/font_model.dart';

class Constants{

  static const String bibleIndex = 'bibleIndex';
  static const String bibleChapter = 'bibleChapter';
  static const String darkMode = 'darkMode';
  static const String backgroundColor = 'background';
  static const String fontSize = 'fontSize';
  static const String fontIndex = 'fontIndex';
  static const String bookmarks = 'bookmarks';
  static const String showReferences = 'showReferences';

  static List<GlobalFontModel> globalFonts = [
    GlobalFontModel(textTheme: GoogleFonts.literataTextTheme(), fontFamily: GoogleFonts.literata().fontFamily!,fontName: "Literata"),
    GlobalFontModel(textTheme: GoogleFonts.libreBaskervilleTextTheme(), fontFamily: GoogleFonts.libreBaskerville().fontFamily!,fontName: "Libre Baskerville"),
    GlobalFontModel(textTheme: GoogleFonts.quicksandTextTheme(), fontFamily: GoogleFonts.quicksand().fontFamily!,fontName: "Quicksand"),
    GlobalFontModel(textTheme: GoogleFonts.ibmPlexSansTextTheme(), fontFamily: GoogleFonts.ibmPlexSans().fontFamily!,fontName: "IBM Plex"),
    GlobalFontModel(textTheme: GoogleFonts.archivoTextTheme(), fontFamily: GoogleFonts.archivo().fontFamily!,fontName: "Archivo"),
    GlobalFontModel(textTheme: GoogleFonts.loraTextTheme(), fontFamily: GoogleFonts.lora().fontFamily!,fontName: "Lora"),
    GlobalFontModel(textTheme: GoogleFonts.sourceSansProTextTheme(), fontFamily: GoogleFonts.sourceSansPro().fontFamily!,fontName: "Source Sans Pro"),
    GlobalFontModel(textTheme: GoogleFonts.montserratTextTheme(), fontFamily: GoogleFonts.montserrat().fontFamily!,fontName: "Montserrat"),
    GlobalFontModel(textTheme: GoogleFonts.workSansTextTheme(), fontFamily: GoogleFonts.workSans().fontFamily!,fontName: "Work Sans"),
    GlobalFontModel(textTheme: GoogleFonts.slabo13pxTextTheme(), fontFamily: GoogleFonts.slabo13px().fontFamily!,fontName: "Slabo 13px"),
    GlobalFontModel(textTheme: GoogleFonts.latoTextTheme(), fontFamily: GoogleFonts.lato().fontFamily!,fontName: "Lato"),
  ];
}