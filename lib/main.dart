import 'package:flutter/material.dart';
import 'package:gch_cityservice/pages/google_maps_page.dart';
import 'package:gch_cityservice/screens/root_screen.dart';
import 'package:gch_cityservice/services/authentication.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_places_picker/google_places_picker.dart';

void main() {

  var location = Location();
  location.onLocationChanged().listen((LocationData currentLocation) {
    lastPosition = LatLng(currentLocation.latitude, currentLocation.longitude);
    //print(currentLocation.latitude);
    //print(currentLocation.longitude);
  });
  ///Not safe code

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Добрый городовой',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'BebasNeue',
          accentColor: const Color.fromRGBO(0x7e, 0x00, 0xff, 1),//0x7e00ff),
        ),
        home: RootScreen(auth: Auth()),
      );
}

ScreenUtil su;
