import 'package:flutter/material.dart';
import 'package:gch_cityservice/pages/section_list_page.dart';
import 'package:gch_cityservice/screens/home_screen.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class BottomDrawerCard extends StatelessWidget {
  MyTask task;

  BottomDrawerCard(this.task);

  double _panelHeightOpen = 500.0;
  double _panelHeightClosed = 95.0;

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      maxHeight: _panelHeightOpen,
      minHeight: _panelHeightClosed,
      parallaxEnabled: true,
      parallaxOffset: .5,
      panel: _panel(),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(18.0),
        topRight: Radius.circular(18.0),
      ),
    );
  }

  Widget _widgetName() {
    return Container(
        height: _panelHeightClosed,
        child: Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(task.title??"Неизвестно", style: TextStyle(fontSize: 20),),
                Text(intToCategory(task.cathegory?.index)??"Нет", style: TextStyle(fontSize: 10),)
              ],
            ),
            Expanded(
              child: Text(task.title),
            ),
            Flexible(
              child: Text(task.snippet??"Пусто"),
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

  Widget _panel() => Column(
        children: <Widget>[
          _widgetName(),
          _widgetGallery(),
          _widgetComments(),
        ],
      );
}
