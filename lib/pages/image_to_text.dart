import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:clay_containers/widgets/clay_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class textRS extends StatefulWidget {
  var backColor, barColor, textColor;
  textRS({
    super.key,
    required this.backColor,
    required this.barColor,
    required this.textColor,
  });
  @override
  _textRSState createState() => _textRSState();
}

class _textRSState extends State<textRS> {
  XFile? pickedImage;
  String mytext = '';
  bool scanning = false;

  final ImagePicker _imagePicker = ImagePicker();
  getImage(ImageSource ourSource) async {
    XFile? result = await _imagePicker.pickImage(source: ourSource);

    if (result != null) {
      setState(() {
        pickedImage = result;
      });
      performTextRecognition();
    }
  }

  performTextRecognition() async {
    setState(() {
      scanning = true;
    });
    try {
      final inputImage = InputImage.fromFilePath(pickedImage!.path);

      final textRecognizer = GoogleMlKit.vision.textRecognizer();

      final recognizedText = await textRecognizer.processImage(inputImage);
      setState(() {
        mytext = recognizedText.text;
        scanning = false;
      });
      textRecognizer.close();
    } catch (e) {
      print('Error during text recognition:$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backColor,
      appBar: AppBar(iconTheme: IconThemeData(color: widget.textColor),
        backgroundColor: widget.barColor,
        title: Text('Text Recognition App',style: TextStyle(color: widget.textColor),),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          pickedImage == null
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  child: ClayContainer(color: widget.barColor,
                    height: 400,
                    child: Center(
                      child: Text('No Image Selected',style: TextStyle(color: widget.textColor)),
                    ),
                  ),
                )
              : Center(
                  child: //Image.network(pickedImage!.path)
                      Image.file(
                  File(pickedImage!.path),
                  height: 400,
                )),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  getImage(ImageSource.gallery);
                },
                icon: Icon(Icons.photo),
                label: Text('Gallery'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  getImage(ImageSource.camera);
                },
                icon: Icon(Icons.camera_alt),
                label: Text('Camera'),
              ),
            ],
          ),
          SizedBox(height: 30),
          Center(child: Text('Recognized Text',style: TextStyle(color: widget.textColor),)),
          SizedBox(height: 10),
          scanning
              ? Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Center(
                    child: SpinKitThreeBounce(color: Colors.black, size: 20),
                  ),
                )
              : Center(
                  child: mytext != ''
                      ? Column(
                          children: [
                            AnimatedTextKit(
                                isRepeatingAnimation: false,
                                animatedTexts: [
                                  TypewriterAnimatedText(mytext,
                                      textAlign: TextAlign.center,
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.bold,color: widget.textColor)),
                                ]),
                            SizedBox(
                              height: 10,
                            ),
                            IconButton(
                                onPressed: () {
                                  Clipboard.setData(
                                      ClipboardData(text: mytext));
                                },
                                icon: Icon(Icons.copy_rounded,color: widget.textColor,)),
                            Text(
                              'Copy to Clipboard',
                              style: TextStyle(fontSize: 10,color: widget.textColor),
                            ),
                          ],
                        )
                      : Text('')),
        ],
      ),
    );
  }
}
