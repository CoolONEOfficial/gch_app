import 'package:flutter/material.dart';
import 'package:gch_cityservice/pages/google_maps_page.dart';
import 'package:gch_cityservice/screens/home_screen.dart';
import 'package:gch_cityservice/screens/root_screen.dart';
import 'package:gch_cityservice/services/authentication.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

void main() {

  var location = Location();
  location.onLocationChanged().listen((LocationData currentLocation) {
    lastPosition = LatLng(currentLocation.latitude, currentLocation.longitude);
    for(var x in tasksSet){
      x.distanceToUser = calcDistance(x.position, lastPosition);
    }
    taskBloc.add(null);
    //print(currentLocation.latitude);
    //print(currentLocation.longitude);
  });
  ///Not safe code

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter login demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'BebasNeue',
          accentColor: const Color.fromRGBO(0x7e, 0x00, 0xff, 1),//0x7e00ff),
        ),
        home: RootScreen(auth: Auth()),
      );
}
