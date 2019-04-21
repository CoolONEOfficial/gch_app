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
      child: ListView.builder(
        // This next line does the trick.
        scrollDirection: Axis.horizontal,
        itemBuilder: (ctx, index) => myPhoto(ctx, index),
        itemCount: widget.task.picUrls.length,
      ),
    );
  }

  Widget myPhoto(ctx, index){
    return Image.network(widget.task.picUrls[index]);
  }


  Widget _widgetComments() {
    return Flexible(
        child: ListView.builder(
          // This next line does the trick.
          scrollDirection: Axis.vertical,
          itemBuilder: (ctx, index) => ListTile(
            leading: const Icon(Icons.comment),
            title: Text('Комментарий '+(index+1).toString()),
          ),
          itemCount: widget.task.picUrls.length,
        ),
//        ListTile(
//          leading: const Icon(Icons.comment),
//          title: const Text('Комментарий 7'),
//        ),
    );
  }
}
