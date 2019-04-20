import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gch_cityservice/google_maps_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:gch_cityservice/pages/root_page.dart';
import 'package:gch_cityservice/services/authentication.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gch_cityservice/section_list.dart';

int activeScreen = 0;

enum sections { MyMap, MyList }
enum neededWidget { Section, AppBar }

final List<List<Widget>> screens = [
  [MyMapWidget(), myMapAppBar()],
  [SectionList(), myListAppBar()],
];

class HomePage extends StatefulWidget {
  HomePage({
    Key key,
    this.auth,
    this.userId,
    this.onSignedOut,
  }) : super(key: key);
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isEmailVerified = false;

  @override
  void initState() {
    _checkEmailVerification().then((result) {
      databaseReference.child("tasks").onValue.listen(
            (event) {
          var tasks = event?.snapshot?.value;

          Set<MyTask> set = Set<MyTask>();

          for (int taskId = 0; taskId < tasks.length; taskId++) {
            var task = tasks[taskId];

            set.add(
              MyTask.defaultClass(
                taskId.toString(),
                LatLng(
                  task["position"]["lat"],
                  task["position"]["lng"],
                ),
                task["name"],
                task["name"],
              ),
            );
          }

          taskBloc.add(set);
        },
      );
    });

    super.initState();
  }

  Future<bool> _checkEmailVerification() async {
    _isEmailVerified = await widget.auth.isEmailVerified();
    if (!_isEmailVerified) {
      _showVerifyEmailDialog();
    }
    return _isEmailVerified;
  }

  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  void _resentVerifyEmail() {
    widget.auth.sendEmailVerification();
    _showVerifyEmailSentDialog();
  }

  void _showVerifyEmailDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Verify your account"),
          content: Text("Please verify account in the link sent to email"),
          actions: <Widget>[
            FlatButton(
              child: Text("Resent link"),
              onPressed: () {
                Navigator.of(context).pop();
                _resentVerifyEmail();
              },
            ),
            FlatButton(
              child: Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Verify your account"),
          content: Text("Link to verify account has been sent to your email"),
          actions: <Widget>[
            FlatButton(
              child: Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => MySection();
}

final databaseReference = FirebaseDatabase.instance.reference();

class MySection extends StatefulWidget {
  @override
  State<MySection> createState() => MySectionState();
}

class MySectionState extends State<MySection> {
  int currentSectionID = sections.MyMap.index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentSectionID][neededWidget.Section.index],
      appBar: screens[currentSectionID][neededWidget.AppBar.index],
      drawer: drawer(context, activeScreen),
    );
  }

  Drawer drawer(BuildContext context, int id) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("Ashish Rawat"),
            accountEmail: Text("ashishrawat2911@gmail.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Theme.of(context).platform == TargetPlatform.iOS
                  ? Colors.blue
                  : Colors.white,
              child: Text(
                "A",
                style: TextStyle(fontSize: 40.0),
              ),
            ),
          ),
          ListTile(
            title: Text("Карта"),
            trailing: Icon(Icons.map),
            onTap: () {
              setState(() {
                Navigator.of(context).pop();
                currentSectionID = sections.MyMap.index;
              });
            },
          ),
          ListTile(
            title: Text("Список"),
            trailing: Icon(Icons.list),
            onTap: () {
              setState(() {
                Navigator.of(context).pop();
                currentSectionID = sections.MyList.index;
              });
            },
          ),
          ListTile(
            title: Text("Обращение"),
            trailing: Icon(Icons.add_circle),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class MyTask {
  MyTask();

  MyTask.defaultClass(this.id, this.position, this.title, this.snippet);

  String title = 'default title';
  String snippet = 'default snippet';
  String id = '1234567890';

  LatLng position = LatLng(56.327752241668215, 44.00208346545696);

  Marker toMarker() {
    var myDescriptor =
    BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);

    if (this is GoodTask) {
      myDescriptor =
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    } else if (this is BadTask) {
      myDescriptor = BitmapDescriptor.defaultMarker;
    }

    return Marker(
      markerId: MarkerId(this.id),
      position: this.position,
      onTap: () => onMarkerTap(this),
      icon: myDescriptor,
    );
  }
}

final taskBloc = StreamController<Set<MyTask>>.broadcast();
