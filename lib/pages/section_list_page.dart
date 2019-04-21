
import 'package:flutter/material.dart';
import 'package:gch_cityservice/screens/home_screen.dart';
import 'package:http/http.dart' as http;

class SectionListPage extends StatefulWidget {
  @override
  State<SectionListPage> createState() => SectionListPageState();
}

class SectionListPageState extends State<SectionListPage> {
  @override
  Widget build(BuildContext context) => StreamBuilder(
        stream: taskBloc.stream,
        initialData: Set(),
        builder: (ctx, snapshot) {
          var list = tasksSet.toList();
          print(snapshot.toString());
          print(list.length);
          return ListView.builder(
            itemBuilder: (ctx, index) => myListTile(ctx, index),
            itemCount: list.length,
          );
        },
      );

  Widget myListTile(BuildContext ctx, int index) {
    MyTask tsk = tasksSet.toList().elementAt(index);
    return GestureDetector(
      onTap: () async {
        var url = "http://192.168.43.211:8080/gch_server_war_exploded/test";
        var client = http.Client();
        var request = http.Request('POST', Uri.parse(url))
          ..bodyFields = {
            'uuid': 'sdfsd',
            'taskid': tsk.id,
          };
        client
            .send(request)
            .then((response) => response.stream
                .bytesToString()
                .then((value) => print(value.toString())))
            .catchError((error) => print(error.toString()));
      },
      child: Card(
          elevation: 10,
          child: Column(
            children: <Widget>[
              Container(height: 8),
              Row(
                children: <Widget>[
                  Container(
                      height: 30,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(8.0),
                              bottomRight: Radius.circular(8.0))),
                      child: Center(
                        child: Text(
                          tsk.title ?? "",
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                  Expanded(
                    child: Container(),
                  ),
                  Container(
                      height: 30,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                          //const Color.fromRGBO(0x7e, 0x00, 0xff, 1),//0x7e00ff),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              bottomLeft: Radius.circular(8.0))),
                      child: Center(
                        child: Text(
                          dateText(tsk.sendTime ??
                              DateTime.utc(2019).millisecondsSinceEpoch),
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                ],
              ),
              Row(
                children: <Widget>[
                  Container(width: 10),
                  Expanded(
                    //width: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Divider(),
                        Text(
                          intToCategory(tsk.category?.index),
                          style: TextStyle(
                              color: Theme.of(context)
                                  .primaryColor /*const Color.fromRGBO(0x00, 0x71, 0x7a, 1)*/),
                        ),
                        Divider(),
                        Text(
                          tsk.snippet ?? "Ясно хуита",
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: const Color.fromRGBO(0x8e, 0x8e, 0x8e, 1)),
                        ),
                        Divider(),
                        Text(
                          "${tsk.distanceToUser} метр(ов) от вас",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        Divider(),
                      ],
                    ),
                  ),
                  Container(
                    width: 10,
                  ),
                  Column(
                    children: <Widget>[
                      Center(
                          child: Container(
                        width: 100,
                        height: 100,
                        child: Image.network(tsk.picUrls[0] ),
                           // "http://sim-kr.ru/UserImages/37cd40ac.jpg"),
                      ))
                    ],
                  ),
                  Container(width: 10)
                ],
              ),
              //Text("Wabba labba dub dub", style: TextStyle(fontSize: 20),)
            ],
          )),
    );
  }

  String dateText(int secs) {
    print(secs.toString());
    var b = DateTime.fromMillisecondsSinceEpoch(secs);
    int day = b.day;
    //int day = DateTime.fromMillisecondsSinceEpoch(secs)?.day;
    int month = DateTime.fromMillisecondsSinceEpoch(secs)?.month;
    String monthString = month.toString();
    if (month < 10) {
      monthString = '0' + monthString;
    }
    monthString = day.toString() + "." + monthString;
    return monthString;
  }
}

final categoryNames = [
  "Нет",
  "Дороги",
  "Вандализм",
  "Транспорт",
  "Мусор",
  "Освещение",
];

String intToCategory(int index) => categoryNames[index ?? 0] ?? categoryNames[0];

AppBar myListAppBar() {
  return AppBar(
    title: Text("Список"),
  );
}
