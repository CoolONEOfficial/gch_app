import 'package:flutter/material.dart';
import 'package:gch_cityservice/pages/root_page.dart';
import 'package:gch_cityservice/services/authentication.dart';

void main() {
  runApp(new MyApp());
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
      home: RootPage(auth: Auth()),
    );
  }
}
