import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeech extends StatelessWidget {
  final FlutterTts flutterTts = FlutterTts();
  final TextEditingController textEditingController = TextEditingController();
  speak(String text) async {
    await flutterTts.setLanguage("en-US");

    //await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1); //0.5 to 1.5
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              controller: textEditingController,
            ), //TextFormField
            ElevatedButton(
              child: Text("Start Text To Speech"),
              onPressed: () => speak(textEditingController.text),
            ) //ElevatedButton
          ], //<Widget>[]
        ), //Column
      ), //Padding
    ); //Container
  }
}
