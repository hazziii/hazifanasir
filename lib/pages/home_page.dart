import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translation/pages/login_page.dart';
import 'package:translator/translator.dart';

import '../main.dart';

// void main() {
//   runApp(MyApp());
// }

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


  final FlutterTts flutterTts = FlutterTts();

  void speak(String text) async {
    await flutterTts.setLanguage("en");
    await flutterTts.setPitch(1); //0.5 to 1.5
    await flutterTts.speak(text);
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                            onPressed: () => speak(inputText),
                            icon: Icon(Icons.speaker),
                          ),
                          Icon(Icons.arrow_forward_outlined),
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
