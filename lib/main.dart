import 'package:flutter/material.dart';
import 'package:gch_cityservice/google_maps_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  StatelessElement createElement() {
    databaseReference.child("tasks").onValue.listen((event) {
      var tasks = event?.snapshot?.value;

      Set<MyTask> set = Set<MyTask>();

      final d  =tasks.map(
            (val) {
          return ;
        },
      );

      for(int taskId = 0; taskId < tasks.length; taskId++) {
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
            )
        );
      }

      debugPrint("d: " + d.toString());

      taskBloc.add(
        set
      );

//      taskBloc.add(set);
    });
    return super.createElement();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'BebasNeue'),
        home: Scaffold(
          body: MyMapWidget(),
        )
        //MyMapWidget()
        ///MyHomePage(title: 'Flutter Demo Home Page'),
        );
  }
}

final databaseReference = FirebaseDatabase.instance.reference();
