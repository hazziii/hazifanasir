import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translation/pages/history.dart';
import 'package:translation/pages/image_to_text.dart';
import 'package:translation/pages/login_page.dart';
import 'package:translation/pages/review.dart';
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

  bool darkMode = false;

  var backColor = Colors.white;
  var barColor = Colors.white;
  var textColor = Colors.black;

  final outputController = TextEditingController(text: "Result here...");
  final translator = GoogleTranslator();
  String inputText = '';
  String inputLanguage = 'English';
  String outputLanguage = 'English';

  void setLightMode() {
    setState(() {
      backColor = Colors.white;
      barColor = Colors.white;
      textColor = Colors.black;
      darkMode = false;
    });
  }

  void setDarkMode() {
    setState(() {
      backColor = Colors.black87;
      barColor = Colors.black;
      textColor = Colors.white;
      darkMode = true;
    });
  }

  Map swapCodes = {
    'English': 'en',
    'French': 'fr',
    'Spanish': 'es',
    'Urdu': 'ur',
    'Hindi': 'hi',
    'Italian': 'it',
    'Korean': 'ko',
    'Chinese': 'cs',
    'Bengali': 'bn',
    'Afrikaans': 'af',
    'Arabic': 'ar',
    'Azerbaijani':'az',
    'German':'de',
    'Greek':'el',
    'Gujarati':'gu',
    'Indonesian':'id',
    'Latin':'la',
    'Marathi':'mr',
    'Nepali':'ne',
    'Punjabi':'pa',


  };

  Future<void> translateText() async {
    final translated = await translator.translate(
      inputText,
      from: swapCodes[inputLanguage],
      to: swapCodes[outputLanguage],
    );
    setState(() {
      outputController.text = translated.text;
    });
    if (inputText.trim().isNotEmpty) {
      addtoHistory(inputText);
    }
  }

  // code for TTS

  final FlutterTts flutterTts = FlutterTts();

  void speakInput(String text) async {
    await flutterTts.setLanguage(swapCodes[inputLanguage]);
    await flutterTts.setPitch(1); //0.5 to 1.5
    await flutterTts.speak(text);
  }

  void speakOutput(String text) async {
    await flutterTts.setLanguage(swapCodes[outputLanguage]);
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

  // code for firebase history

  getId() {
    final User? user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    return uid;
  }

  void addtoHistory(String inputData) {
    String uid = getId();

    final databaseRef = FirebaseDatabase.instance.ref(uid).child(inputData);
    databaseRef.update({'data': inputData});
    print('Added to history ' + inputData);
  }

  @override
  Widget build(BuildContext context) {
    inputController.addListener(
      () {
        translateText();
      },
    );
    String uid = getId();

    return Scaffold(
      backgroundColor: backColor,
      appBar: AppBar(
        backgroundColor: barColor,
        leading: darkMode == false
            ? IconButton(
                onPressed: () {
                  setDarkMode();
                },
                icon: Icon(Icons.dark_mode_rounded))
            : IconButton(
                onPressed: () {
                  setLightMode();
                },
                icon: Icon(
                  Icons.light_mode_rounded,
                  color: Colors.white,
                )),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => HistoryPage(
                    userID: uid,
                  ),
                ));
              },
              icon: Icon(
                Icons.history,
                color: textColor,
              )),
        ],
        //leading:
      ),
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
                        style: TextStyle(color: textColor),
                        controller: inputController,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: textColor),
                          border: OutlineInputBorder(),
                          hintText: "Enter Text to translate",
                        ),
                        onTapOutside: (event) {
                          translateText;
                        },
                        onSubmitted: (value) {
                          translateText;
                        },
                        onTap: () => {translateText},
                        onEditingComplete: () {
                          translateText;
                        },
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
                                dropdownColor: backColor,
                                style: TextStyle(color: textColor),
                                value: inputLanguage,
                                onChanged: (newValue) {
                                  setState(() {
                                    inputLanguage = newValue!;
                                  });
                                },
                                items: <String>[
                                  'English',
                                  'French',
                                  'Spanish',
                                  'Urdu',
                                  'Hindi',
                                  'Italian',
                                  'Korean',
                                  'Chinese',
                                  'Bengali',
                                  'Afrikaans',
                                  'Arabic',
                                  'Azerbaijani',
                                  'German',
                                  'Greek',
                                  'Gujarati',
                                  'Indonesian',
                                  'Latin',
                                  'Marathi',
                                  'Nepali',
                                  'Punjabi',


                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                              IconButton(
                                onPressed: () => speakInput(inputText),
                                icon: Icon(
                                  Icons.volume_up,
                                  color: textColor,

                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              var temp;
                              temp = inputLanguage;
                              inputLanguage = outputLanguage;
                              outputLanguage = temp;
                              setState(() {});
                            },
                            child: Icon(
                              Icons.swap_horiz_rounded,
                              color: textColor,
                            ),
                          ),
                          Row(
                            children: [
                              DropdownButton<String>(
                                dropdownColor: backColor,
                                style: TextStyle(color: textColor),
                                value: outputLanguage,
                                onChanged: (newValue) {
                                  setState(() {
                                    outputLanguage = newValue!;
                                  });
                                },
                                items: <String>[
                                  'English',
                                  'French',
                                  'Spanish',
                                  'Urdu',
                                  'Hindi',
                                  'Italian',
                                  'Korean',
                                  'Chinese',
                                  'Bengali',
                                  'Afrikaans',
                                  'Arabic',
                                  'Azerbaijani',
                                  'German',
                                  'Greek',
                                  'Gujarati',
                                  'Indonesian',
                                  'Latin',
                                  'Marathi',
                                  'Nepali',
                                  'Punjabi',
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
                                icon: Icon(
                                  Icons.volume_up,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => textRS(
                                backColor: backColor,
                                barColor: barColor,
                                textColor: textColor,
                              ),
                            ));
                          },
                          icon: Icon(
                            Icons.camera_alt,
                            color: textColor,
                          )),
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
                        maxLines: null,
                        style: TextStyle(color: textColor),
                        controller: outputController,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: textColor),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            inputText = value;
                          });
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: TextButton.icon(
                          style: TextButton.styleFrom(
                            backgroundColor: textColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          onPressed: () {
                            showAlertDialog(BuildContext context) {
                              // set up the buttons
                              Widget cancelButton = ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.black87),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  )),
                                ),
                                child: const Text("Cancel",
                                    style: TextStyle(color: Colors.white)),
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                },
                              );
                              Widget yesButton = ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.black87),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  )),
                                ),
                                child: const Text(
                                  "Yes",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () async {
                                  await FirebaseAuth.instance.signOut();
                                  //createToast('Logged Out');
                                  setState(() {});
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  Navigator.pushReplacement(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) =>
                                              const LoginPage()));
                                },
                              );
                              AlertDialog alert = AlertDialog(
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(30.0))),
                                title: const Text("Confirmation"),
                                content:
                                    const Text("Would you like to Logout?"),
                                actions: [
                                  cancelButton,
                                  yesButton,
                                ],
                              );
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return alert;
                                },
                              );
                            }

                            showAlertDialog(context);
                          },
                          icon: Icon(
                            Icons.logout_rounded,
                            color: backColor,
                          ),
                          label: Text(
                            'Logout',
                            style: TextStyle(color: backColor),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: textColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ReviewPage(),
                            ));
                          },
                          child: Text(
                            'Review Us',
                            style: TextStyle(color: backColor),
                          ))
                    ],
                  )))),
    );
  }
}
