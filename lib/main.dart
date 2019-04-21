import 'package:flutter/material.dart';
import 'package:gch_cityservice/screens/root_screen.dart';
import 'package:gch_cityservice/services/authentication.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_places_picker/google_places_picker.dart';

void main() {
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
      ),
      home: RootScreen(auth: Auth()),
    );
  }
}

ScreenUtil su;
