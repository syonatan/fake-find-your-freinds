// adapted from the following tutorial https://heartbeat.fritz.ai/firebase-user-authentication-in-flutter-1635fb175675

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MeetingCustomCard extends StatelessWidget {
  MeetingCustomCard({@required this.course, this.date, this.description, this.location, this.time, this.title, this.uid, this.userUID});

  // information on the card about the meeting
  final course;
  final date;
  final description;
  final location;
  final time;
  final title;
  final uid;
  final userUID;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Container(
            padding: const EdgeInsets.only(top: 5.0),
            child: Column(
              children: <Widget>[
                Text(title),
                FlatButton(
                    child: Text("See More"),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Scaffold(
                                  appBar: AppBar(
                                    title: Text(title),
                                  ),
                                  body: Center(
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text("Class: " + course),
                                          //TODO fix date and time not printing, error message: "type 'Timestamp' is not a subtype of type 'String'"
                                          //Text("Date: " + date),
                                          //Text("Time: " + time),
                                          Text("Location: " + location),
                                          Text("Description: " + description),
                                          RaisedButton(
                                            
                                            child: Text("Join"),
                                            color: Theme.of(context).primaryColor,
                                            textColor: Colors.white,
                                            onPressed: () {
                                              Firestore.instance
                                                  .collection("meetings")
                                                  .document(uid)
                                                  .collection('attendees')
                                                  .add({
                                                "userUID": userUID,
                                              }).catchError((err) => print(err));

                                              Firestore.instance
                                                  .collection("users")
                                                  .document(userUID)
                                                  .collection('meetings')
                                                  .add({
                                                "meetingUID": uid,
                                                "class": course,
                                                "date": date,
                                                "description": description,
                                                "location": location,
                                                "time": time,
                                                "title": title
                                              }).catchError((err) => print(err));

                                              Navigator.pop(context);
                                            },
                                          ),
                                          RaisedButton(
                                              child: Text('Back To HomeScreen'),
                                              color: Theme.of(context).primaryColor,
                                              textColor: Colors.white,
                                              onPressed: () => Navigator.pop(context)),
                                        ]),
                                  )),
                          ));
                    }),
              ],
            )));
  }
}