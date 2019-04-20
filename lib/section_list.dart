import 'package:flutter/material.dart';

class SectionList extends StatefulWidget {
  @override
  State<SectionList> createState() => SectionListState();
}

class SectionListState extends State<SectionList> {

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