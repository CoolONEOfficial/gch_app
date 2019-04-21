import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gch_cityservice/pages/google_maps_page.dart';
import 'package:gch_cityservice/screens/home_screen.dart';
import 'package:gch_cityservice/screens/root_screen.dart';
import 'package:gch_cityservice/services/authentication.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:latlong/latlong.dart' as LutLonh;

var location = Location();

void main() {
  LutLonh.Distance dis = LutLonh.Distance();
  location.onLocationChanged().listen((LocationData currentLocation) {
    lastPosition = LatLng(currentLocation.latitude, currentLocation.longitude);
    for(var x in tasksSet){
      x.distanceToUser = dis(LutLonh.LatLng(x.position.latitude, x.position.longitude),
          LutLonh.LatLng(lastPosition.latitude, lastPosition.longitude)).round();//calcDistance(x.position, lastPosition);
    }
    taskBloc.add(null);
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter login demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'BebasNeue',
        accentColor: const Color.fromRGBO(0x7e, 0x00, 0xff, 1),
      ),
      home: Builder(builder: (ctx) {
        ScreenUtil.instance = ScreenUtil(width: 1080, height: 1920)..init(ctx);
        return RootScreen(auth: Auth());
      },),
    );
  }
}
