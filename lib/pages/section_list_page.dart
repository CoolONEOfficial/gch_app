import 'package:flutter/material.dart';
import 'package:gch_cityservice/screens/home_screen.dart';
import 'package:gch_cityservice/widget_templates.dart';

class SectionListPage extends StatefulWidget {
  @override
  State<SectionListPage> createState() => SectionListPageState();
}

class SectionListPageState extends State<SectionListPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: taskBloc.stream,
      initialData: Set(),
      builder: (ctx, snapshot) {
        var list = tasksSet.toList();
        return ListView.builder(
          itemBuilder: (ctx, index) => ListTile(
                title: Text(list[index].title),
              ),
          itemCount: list.length,
        );
      },
    );
  }
}

AppBar myListAppBar() {
  return AppBar(
    title: Text("MyList"),
  );
}
