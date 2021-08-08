import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindi_bible/logics/providers.dart';

class FontSliderWidget extends StatefulWidget {

  @override
  _FontSliderWidgetState createState() => _FontSliderWidgetState();
}

class _FontSliderWidgetState extends State<FontSliderWidget> {

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context,watch,child) {
        return SliderTheme(
          data: SliderThemeData(
            trackHeight: 1.5,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7.0),),
          child: Slider(
            // divisions: 18,
            min: 12.0,
            max: 30.0,
            value: watch(fontSizeProvider).state,
            inactiveColor: Colors.grey[500],
            onChanged: (value) {
            context.read(fontSizeProvider).state = value;
            },
            onChangeEnd: (value) {
              context.read(boxStorageProvider).saveFontSize(value);
            },
          ),
        );
      }
    );
  }
}
