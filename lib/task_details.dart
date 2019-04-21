import 'package:flutter/material.dart';
import 'package:gch_cityservice/pages/google_maps_page.dart';
import 'package:gch_cityservice/pages/section_list_page.dart';
import 'package:gch_cityservice/screens/home_screen.dart';

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
        _widgetGallery(),
        _widgetComments(),
      ],
    );
  }

  Widget _widgetName(context) {
    return Container(
        height: panelHeightClosed,
        child: Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                Divider(),
                //Text(task.title??"Неизвестно", style: TextStyle(fontSize: 20),),
                Text(
                  intToCategory(widget.task.category?.index) ?? "Нет",
                  style: TextStyle(fontSize: 20),
                ),
                Divider(),
                Container(
                    height: 40,
                    width: 150,
                    decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        //const Color.fromRGBO(0x7e, 0x00, 0xff, 1),//0x7e00ff),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0))),
                    child: Center(
                      child: Text(
                        widget.task.title,
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                    )),
              ],
            ),
            Expanded(
              child: Text(widget.task.title),
            ),
            Flexible(
              child: Text(widget.task.snippet ?? "Пусто"),
            )
          ],
        ));
  }

  Widget _widgetGallery() {
    return Container(
      height: 100,
      child: ListView(
        // This next line does the trick.
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Container(
            width: 100.0,
            child: Image.network("http://sim-kr.ru/UserImages/37cd40ac.jpg"),
          ),
          Container(
            width: 100.0,
            child: Image.network("http://sim-kr.ru/UserImages/37cd40ac.jpg"),
          ),
          Container(
            width: 100.0,
            child: Image.network("http://sim-kr.ru/UserImages/37cd40ac.jpg"),
          ),
          Container(
            width: 100.0,
            child: Image.network("http://sim-kr.ru/UserImages/37cd40ac.jpg"),
          ),
          Container(
            width: 100.0,
            child: Image.network("http://sim-kr.ru/UserImages/37cd40ac.jpg"),
          ),
        ],
      ),
    );
  }

  Widget _widgetComments() {
    return Flexible(
        child: ListView(
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.comment),
          title: const Text('Комментарий 1'),
        ),
        ListTile(
          leading: const Icon(Icons.comment),
          title: const Text('Комментарий 2'),
        ),
        ListTile(
          leading: const Icon(Icons.comment),
          title: const Text('Комментарий 3'),
        ),
        ListTile(
          leading: const Icon(Icons.comment),
          title: const Text('Комментарий 4'),
        ),
        ListTile(
          leading: const Icon(Icons.comment),
          title: const Text('Комментарий 5'),
        ),
        ListTile(
          leading: const Icon(Icons.comment),
          title: const Text('Комментарий 6'),
        ),
        ListTile(
          leading: const Icon(Icons.comment),
          title: const Text('Комментарий 7'),
        ),
      ],
    ));
  }
}
