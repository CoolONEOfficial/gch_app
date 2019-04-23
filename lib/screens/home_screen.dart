import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gch_cityservice/pages/google_maps_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:gch_cityservice/pages/section_list_page.dart';
import 'package:gch_cityservice/screens/add_task_screen.dart';
import 'package:gch_cityservice/services/authentication.dart';
import 'package:gch_cityservice/widget_templates.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';

int activeScreen = 0;

enum sections { MyMap, MyList }
enum neededWidget { Section, AppBar }

final List<List<Widget>> screens = [
  [MyMapWidget(), myMapAppBar()],
  [SectionListPage(), myListAppBar()],
];

class HomeScreen extends StatefulWidget {
  HomeScreen({
    Key key,
    this.auth,
    this.userId,
    this.onSignedOut,
  }) : super(key: key);
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isEmailVerified = false;

  @override
  void initState() {
    _checkEmailVerification().then((result) {
      databaseReference.child("tasks").onValue.listen(
        (event) {
          var _tasks = event?.snapshot?.value;

          Set<MyTask> set = Set<MyTask>();

          for (int taskId = 0; taskId < _tasks?.length ?? 0; taskId++) {
            var task = _tasks[taskId];

            var cat = task["category"];

            if(cat is double)
              cat = (cat as double).toInt();

            set.add(
              MyTask.pro(
                taskId.toString(),
                -1,
                task["title"],
                task["snippet"],
                Category.values[ cat  ],
                task["time"],
                LatLng(
                  task["position"]["lat"],
                  task["position"]["lng"],
                ),
                task["photoUrls"] ?? List(),
                task["address"],
              ),

              //todo get urls
            );
          }

          tasksSet = set;

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
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Плдтверждение аккаунта"),
          content: Text(
              "Перейдите по ссылке в письме отправленном на вашу электронную почту"),
          actions: <Widget>[
            FlatButton(
              child: Text("Отправить письмо еще раз"),
              onPressed: () {
                Navigator.of(context).pop();
                _resentVerifyEmail();
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
          title: Text("Подтверждение аккаунта"),
          content: Text(
              "Перейдите по ссылке в письме отправленном на вашу электронную почту"),
          actions: <Widget>[
            FlatButton(
              child: Text("Ок"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  int currentSectionID = sections.MyMap.index;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: screens[currentSectionID][neededWidget.Section.index],
        appBar: screens[currentSectionID][neededWidget.AppBar.index],
        drawer: drawer(context, activeScreen),
      );

  Drawer drawer(BuildContext context, int id) {
    return Drawer(
      child: Column(
        children: <Widget>[
          buildFutureBuilder(
            context,
            future: firebaseAuth.currentUser(),
            builder: (ctx, snapshot) {
              return UserAccountsDrawerHeader(
                  accountName:
                      Text(snapshot.data.displayName ?? "Unknown name"),
                  accountEmail: Text(snapshot.data.email ?? "unknown@mail.com"),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).platform == TargetPlatform.iOS
                            ? Colors.blue
                            : Colors.white,
                    child: Image.network(snapshot.data.photoUrl ??
                        "http://www.sclance.com/pngs/image-placeholder-png/image_placeholder_png_698411.png"),
                  ));
            },
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
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => AddTaskScreen(),
                ),
              );
            },
          ),
          Divider(),
          ListTile(
            title: Text("Выйти"),
            trailing: Icon(Icons.exit_to_app),
            onTap: () => _signOut(),
          ),
        ],
      ),
    );
  }
}

final databaseReference = FirebaseDatabase.instance.reference();

final storageReference = FirebaseStorage.instance.ref();

enum Category { None, Road, Vandal, Transport, Litter, Lights }

class MyTask {
  MyTask();

  MyTask.defaultClass(this.id, this.position, this.title, this.snippet);

  MyTask.pro(this.id, this.distanceToUser, this.title, this.snippet,
      this.category, this.sendTime, this.position, this.picUrls, this.address);

  String    title = 'default title';
  String    id = '1234567890';
  LatLng    position = LatLng(56.327752241668215, 44.00208346545696);
  String    address = "Unknown address";
  int       distanceToUser = -1;
  String    snippet = 'default snippet';
  Category  category = Category.None;
  int       sendTime = DateTime.utc(2019).millisecondsSinceEpoch;
  //bool      checkedByUser = false;
  List<dynamic>  picUrls = [];

  Future toDatabase(DatabaseReference ref) async {
    return ref.set({
      "title": title,
      "snippet": snippet,
      "votes": [(await firebaseAuth.currentUser()).uid],
      "address": address,
      "position": {
        "lat": position.latitude,
        "lng": position.longitude,
      },
      "category": category.index,
      "sendTime": DateTime.now().millisecondsSinceEpoch,
      "photoUrls": picUrls,
    });
  }

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

class GoodTask extends MyTask {
  GoodTask(String id, LatLng position, String title, String snippet)
      : super.defaultClass(id, position, title, snippet);
}

class BadTask extends MyTask {
  BadTask(String id, LatLng position, String title, String snippet)
      : super.defaultClass(id, position, title, snippet);
}

Set<MyTask> tasksSet = Set();
final taskBloc = StreamController<void>.broadcast();
