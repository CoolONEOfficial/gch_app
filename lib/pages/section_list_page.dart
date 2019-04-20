import 'package:flutter/material.dart';

class SectionListPage extends StatefulWidget {
  @override
  State<SectionListPage> createState() => SectionListPageState();
}

class SectionListPageState extends State<SectionListPage> {

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text("task 1"),
        ),
        ListTile(
          title: Text("task 2"),
        ),
        ListTile(
          title: Text("task 3"),
        )
      ],
    );
  }
}

AppBar myListAppBar(){
  return AppBar(
    title: Text("MyList"),
  );
}