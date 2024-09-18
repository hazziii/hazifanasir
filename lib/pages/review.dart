import 'package:flutter/material.dart';

class ReviewPage extends StatelessWidget {
  const ReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(iconTheme: IconThemeData(color: Colors.white),

        backgroundColor: Colors.indigo,
        title: Text('Leave us a Review',style: TextStyle(color: Colors.white),),
      ),
      body: SafeArea(bottom: true,
        child: Column(
          children: [
            SizedBox(height: 20),
            TextField(
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
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ReviewPage(),
                  ));
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
