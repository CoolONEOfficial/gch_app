import 'package:flutter/material.dart';
import 'package:gch_cityservice/google_maps_page.dart';
import 'package:gch_cityservice/section_list.dart';

void main() => runApp(MyApp());

int activeScreen = 0;

enum sections { MyMap, MyList }
enum neededWidget { Section, AppBar }

final List<List<Widget>> screens = [
  [MyMapWidget(), myMapAppBar()],
  [SectionList(), myListAppBar()],
];

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'BebasNeue'
      ),
      home: MySection()
      //MyMapWidget()
      ///MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}



class MySection extends StatefulWidget {
  @override
  State<MySection> createState() => MySectionState();
}

class MySectionState extends State<MySection> {

  int currentSectionID = sections.MyMap.index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentSectionID][neededWidget.Section.index],
      appBar: screens[currentSectionID][neededWidget.AppBar.index],
      drawer: drawer(context, activeScreen),

    );
  }

  Drawer drawer(BuildContext context, int id){
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("Ashish Rawat"),
            accountEmail: Text("ashishrawat2911@gmail.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor:
              Theme.of(context).platform == TargetPlatform.iOS
                  ? Colors.blue
                  : Colors.white,
              child: Text(
                "A",
                style: TextStyle(fontSize: 40.0),
              ),
            ),
          ),
          ListTile(
            title: Text("Карта"),
            trailing: Icon(Icons.map),
            onTap: (){
              setState(() {
                Navigator.of(context).pop();
                currentSectionID = sections.MyMap.index;
              });
            },
          ),
          ListTile(
            title: Text("Список"),
            trailing: Icon(Icons.list),
            onTap: (){
              setState(() {
                Navigator.of(context).pop();
                currentSectionID = sections.MyList.index;
              });
            },
          ),
          ListTile(
            title: Text("Обращение"),
            trailing: Icon(Icons.add_circle),
            onTap: (){

            },
          ),
        ],
      ),
    );
  }
}
