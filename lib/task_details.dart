import 'package:flutter/material.dart';
import 'package:gch_cityservice/pages/google_maps_page.dart';
import 'package:gch_cityservice/pages/section_list_page.dart';
import 'package:gch_cityservice/screens/home_screen.dart';
import 'package:gch_cityservice/services/authentication.dart';
import 'package:http/http.dart' as http;

class TaskDetails extends StatefulWidget {
  final MyTask task;

  const TaskDetails(this.task);

  @override
  _TaskDetailsState createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _widgetName(context),
        _widgetDesc(),
        _widgetGallery(),
        _widgetComments(),
      ],
    );
  }

  Widget _widgetDesc(){
    return Padding(
      padding: EdgeInsets.all(10),
      child: Text(widget.task.snippet ?? "Пусто"),
    );
  }

  Widget _widgetName(context) {
    return Container(
        height: panelHeightClosed,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Container(height: 10,),
                  //Text(task.title??"Неизвестно", style: TextStyle(fontSize: 20),),
                  Text(
                    intToCategory(widget.task.category?.index) ?? "Нет",
                    style: TextStyle(fontSize: 20),
                  ),
                  Container(height: 10,),
                  Container(
                      height: 40,
                      //width: 150,
                      decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                          //const Color.fromRGBO(0x7e, 0x00, 0xff, 1),//0x7e00ff),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(8.0),
                              bottomRight: Radius.circular(8.0))),
                      child: Center(
                        child: Text(
                          widget.task.title,
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      )),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: MaterialButton(
                  elevation: 10,
                  child: const Text("Подписать", style: TextStyle(fontSize: 40),),
                  onPressed: () => onButtonSignPress()
                ),
              ),
            ),
//            Flexible(
//              child: Text(widget.task.snippet ?? "Пусто"),
//            )
          ],
        ));
  }

  onButtonSignPress() async {
    var url = "http://192.168.43.211:8080/gch_server_war_exploded/test";
    var client = http.Client();
    var request = http.Request('POST', Uri.parse(url))
      ..bodyFields = {
        'uuid': (await firebaseAuth.currentUser()).uid,
        'taskid': widget.task.id,
      };
    client
        .send(request)
        .then((response) => response.stream
        .bytesToString()
        .then((value) => print(value.toString())))
        .catchError((error) => print(error.toString()));
  }

  Widget _widgetGallery() {
    return Container(
      height: 100,
      child: ListView.builder(
        // This next line does the trick.
        scrollDirection: Axis.horizontal,
        itemBuilder: (ctx, index) => myPhoto(ctx, index),
        itemCount: widget.task?.picUrls?.length ?? 0,
      ),
    );
  }

  Widget myPhoto(ctx, index) {
    return Image.network(widget.task.picUrls[index]);
  }

  Widget _widgetComments() {
    return Flexible(
      child: ListView.builder(
        // This next line does the trick.
        scrollDirection: Axis.vertical,
        itemBuilder: (ctx, index) => ListTile(
              leading: const Icon(Icons.comment),
              title: Text('Комментарий ' + (index + 1).toString()),
            ),
        itemCount: 11,
      ),
//        ListTile(
//          leading: const Icon(Icons.comment),
//          title: const Text('Комментарий 7'),
//        ),
    );
  }
}
