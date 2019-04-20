import 'package:flutter/material.dart';
import 'package:gch_cityservice/screens/root_screen.dart';
import 'package:gch_cityservice/services/authentication.dart';

void main() {
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
        ),
        home: RootScreen(auth: Auth()),
      );
}
