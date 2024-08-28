import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  final String userID;
  const HistoryPage({super.key, required this.userID});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final databaseRef = FirebaseDatabase.instance.ref(widget.userID);
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Container(
          width: deviceWidth,
          height: 480,
          child: Column(
            children: [
              Expanded(
                  child: FirebaseAnimatedList(
                      defaultChild:
                          const Center(child: CircularProgressIndicator()),
                      query: databaseRef,
                      itemBuilder: (context, snapshot, animation, index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 1,
                          color: Colors.white.withOpacity(0.5),
                          child: ListTile(
                            title: Text(
                              snapshot.child('data').value.toString(),
                              style: const TextStyle(fontSize: 22),
                              textAlign: TextAlign.center,
                            ),
                            //subtitle: Text('hello'),
                          ),
                        );
                      })),
            ],
          ),
        ),
      ),
    );
  }
}
