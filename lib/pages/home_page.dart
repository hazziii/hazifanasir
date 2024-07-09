import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translation/pages/login_page.dart';
import 'package:translator/translator.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (user != null)
              Text('Logged in as: ${user.email}',
                  style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //translation code

  final outputController = TextEditingController(text: "Result here...");
  final translator = GoogleTranslator();
  String inputText = '';
  String inputLanguage = 'en';
  String outputLanguage = 'fr';

  Future<void> translateText() async {
    final translated = await translator.translate(
      inputText,
      from: inputLanguage,
      to: outputLanguage,
    );
    setState(() {
      outputController.text = translated.text;
    });
  }

  // code for TTS

  final FlutterTts flutterTts = FlutterTts();


  void speakInput(String text) async {
    await flutterTts.setLanguage(inputLanguage);
    await flutterTts.setPitch(1); //0.5 to 1.5
    await flutterTts.speak(text);
  }

  void speakOutput(String text) async {
    await flutterTts.setLanguage(outputLanguage);
    await flutterTts.setPitch(1); //0.5 to 1.5
    await flutterTts.speak(text);
  }

  // code for STT

  var textSpeech = "Click On Mic To Record";
  SpeechToText speechToText = SpeechToText();
  var isListening = false;

  final inputController = TextEditingController();

  void checkMic() async {
    bool micAvailable = await speechToText.initialize();
    if (micAvailable) {
      print("Microphone Available");
    } else {
      print("User Denied the use of speech micro");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Image.asset(
                        "assets/img.png",
                        fit: BoxFit.contain,
                        height: 250,
                      ),
                      TextField(
                        controller: inputController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Enter Text to translate",
                        ),
                        onChanged: (value) {
                          setState(() {
                            inputText = value;
                          });
                        },
                      ),
                      SizedBox(height: 16),
                      GestureDetector(
                        child: CircleAvatar(
                            child: isListening
                                ? Icon(Icons.record_voice_over)
                                : Icon(Icons.mic)),
                        onTap: () async {
                          if (!isListening) {
                            bool micAvailable = await speechToText.initialize();
                            if (micAvailable) {
                              setState(() {
                                isListening = true;
                              });
                              speechToText.listen(
                                  listenFor: Duration(seconds: 20),
                                  onResult: (result) {
                                    setState(() {
                                      textSpeech = result.recognizedWords;
                                      isListening = false;
                                    });
                                    setState(() {
                                      inputController.text = textSpeech;
                                      inputText = textSpeech;
                                    });
                                  });
                            }
                          } else {
                            setState(() {
                              isListening = false;
                              speechToText.stop();
                            });
                          }
                        },
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              DropdownButton<String>(
                                value: inputLanguage,
                                onChanged: (newValue) {
                                  setState(() {
                                    inputLanguage = newValue!;
                                  });
                                },
                                items: <String>[
                                  'en',
                                  'fr',
                                  'es',
                                  'de',
                                  'ur',
                                  'hi',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                              IconButton(
                                onPressed: () => speakInput(inputText),
                                icon: Icon(Icons.volume_up),
                              ),
                            ],
                          ),
                          Icon(Icons.arrow_forward_outlined),
                          Row(
                            children: [
                              DropdownButton<String>(
                                value: outputLanguage,
                                onChanged: (newValue) {
                                  setState(() {
                                    outputLanguage = newValue!;
                                  });
                                },
                                items: <String>[
                                  'en',
                                  'fr',
                                  'ur',
                                  'hi',
                                  'ru',
                                  'af',
                                  'bn',
                                  'bs',
                                  'cs',
                                  'ko',
                                  'it',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                              IconButton(
                                onPressed: () => speakOutput(
                                    outputController.text.toString()),
                                icon: Icon(Icons.volume_up),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: translateText,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                          minimumSize: Size.fromHeight(55),
                        ),
                        child: Text("Translate"),
                      ),
                      SizedBox(height: 30),
                      TextField(
                        controller: outputController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            inputText = value;
                          });
                        },
                      )
                    ],
                  )))),
    );
  }
}
