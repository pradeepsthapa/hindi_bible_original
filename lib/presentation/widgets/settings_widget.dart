import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindi_bible/constants/constants.dart';
import 'package:hindi_bible/logics/providers.dart';
import 'package:hindi_bible/model/font_model.dart';

import 'font_slider_widget.dart';

class SettingWidget{
  static void showSettingsDialog({required BuildContext context}){
    showModal(
        context: context,
        configuration: FadeScaleTransitionConfiguration(
            barrierColor: Colors.black.withOpacity(0.3),
            barrierDismissible: true),
        builder: (_) {
          return Align(
              alignment: Alignment.topCenter,
              child: Card(
                margin: const EdgeInsets.fromLTRB(12, 30, 12, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      dense: true,
                      title: Text("Settings",style: TextStyle(color: Theme.of(context).colorScheme.secondaryVariant,fontSize: 18),),
                    ),
                    const Divider(height: 0,thickness: 0.7,),
                    Consumer(
                      builder: (context, ref, child) {
                        return SwitchListTile(
                            dense: true,
                            title: const Text("Dark Mode"),
                            value: Theme.of(context).brightness==Brightness.dark,
                            onChanged: (value){
                              ref.read(boxStorageNotifier).changeDarkTheme(value);
                            });
                      },
                    ),
                    const Divider(height: 0,thickness: 0.7,),
                    Consumer(
                      builder: (context, ref, child) {
                        return CheckboxListTile(
                            dense: true,
                            title: const Text("Always Show References"),
                            subtitle: const Text("Toggle on or off reference verses"),
                            value: ref.watch(showReferencesProvider),
                            onChanged: (value){
                              ref.watch(boxStorageNotifier).showHideReferences(value??false);
                            });
                      },
                    ),
                    const Divider(height: 0,thickness: 0.7,),
                    Consumer(builder: (context, ref, child) {
                      return ListTile(
                        title: const Text("Primary Font"),
                        trailing: const Icon(Icons.chevron_right),
                        subtitle: Text(Constants.globalFonts[ref.watch(globalFontProvider.notifier).state].fontName??''),
                        onTap: (){
                          showGeneralDialog(
                            context: context,
                            barrierDismissible: true,
                            barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                            pageBuilder: (context, anim1, anim2) {
                              return AlertDialog(
                                actions: [
                                  TextButton(
                                      onPressed: ()=>Navigator.pop(context),
                                      child: const Text("Cancel")),
                                ],
                                contentPadding: EdgeInsets.zero,
                                scrollable: true,
                                title: Text("Select Font",style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
                                content: SingleChildScrollView(
                                  child: Consumer(
                                      builder: (context,ref, child) {
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: Constants.globalFonts.map((e) => RadioListTile<GlobalFontModel>(
                                            dense: true,
                                            title: Text(e.fontName??''),
                                            groupValue: Constants.globalFonts[ref.watch(globalFontProvider)],
                                            value: e,
                                            onChanged: (value){
                                              final fontIndex = Constants.globalFonts.indexOf(value!);
                                              ref.read(boxStorageNotifier).saveFontStyle(fontIndex);
                                              Navigator.pop(context);
                                            },
                                          )).toList(),
                                        );
                                      }
                                  ),
                                ),
                              );
                            },);
                        },
                      );
                    },),
                    const Divider(height: 0,thickness: 0.7,),
                    const FontSliderWidget(),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(onPressed: (){
                        Navigator.pop(context);
                      }, child: Text("Close",style: TextStyle(color: Theme.of(context).colorScheme.secondary),)),
                    )
                  ],
                ),
              ));
        });
  }
}