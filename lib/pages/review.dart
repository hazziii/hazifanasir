import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ReviewPage extends StatelessWidget {
  ReviewPage({super.key});

  getId() {
    final User? user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    return uid;
  }

  void saveReview(String inputData) {
    String uid = getId();

    final databaseRef = FirebaseDatabase.instance.ref(uid).child(inputData);
    databaseRef.update({'review': inputData});
    print('Added to history ' + inputData);
  }

  final InputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.indigo,
        title: Text(
          'Leave us a Review',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        bottom: true,
        child: Column(
          children: [
            SizedBox(height: 20),
            TextField(
              controller: InputController,
              maxLines: 6,
              style: TextStyle(color: Colors.indigo),
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.indigo),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                onPressed: () {
                  if (InputController.text.trim().isNotEmpty) {
                    saveReview(InputController.text.toString().trim());
                    Fluttertoast.showToast(
                        msg: "Thanks for your feedback",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 8,
                        backgroundColor: Colors.teal,
                        textColor: Colors.white,
                        fontSize: 30.0);
                  } else {
                    Fluttertoast.showToast(
                        msg: "Share Your thoughts",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 8,
                        backgroundColor: Colors.teal,
                        textColor: Colors.white,
                        fontSize: 30.0);
                  }
                },
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }
}
