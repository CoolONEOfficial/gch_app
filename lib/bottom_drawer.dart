import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gch_cityservice/pages/section_list_page.dart';
import 'package:gch_cityservice/screens/home_screen.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class BottomDrawerCard extends StatefulWidget {
  MyTask task;

  BottomDrawerCard(this.task);

  @override
  _BottomDrawerCardState createState() => _BottomDrawerCardState();
}

class _BottomDrawerCardState extends State<BottomDrawerCard> {
  double _panelHeightOpen = 500.0;

  double _panelHeightClosed = 95.0;

  double bordersRadius = 0;

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      maxHeight: ScreenUtil.getInstance().setHeight(1800),
      minHeight: _panelHeightClosed,
      parallaxEnabled: true,
      backdropEnabled: true,
      parallaxOffset: .5,
      panel: _panel(context),
      onPanelSlide: (pos) {
        setState(() {
          bordersRadius = pos;
        });
      },
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular((1 - bordersRadius) * 20),
        topRight: Radius.circular((1 - bordersRadius) * 20),
      ),
    );
  }

  Widget _widgetName(context) {
    return Container(
        height: _panelHeightClosed,
        child: Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                Divider(),
                //Text(task.title??"Неизвестно", style: TextStyle(fontSize: 20),),
                Text(intToCategory(widget.task.cathegory?.index)??"Нет", style: TextStyle(fontSize: 20),),
                Divider(),
                Container(
                    height: 40,
                    width: 150,
                    decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,//const Color.fromRGBO(0x7e, 0x00, 0xff, 1),//0x7e00ff),
                        borderRadius: BorderRadius.only(topRight: Radius.circular(8.0), bottomRight: Radius.circular(8.0))
                    ),
                    child: Center(
                      child: Text(widget.task.title, style: TextStyle(color: Colors.white, fontSize: 30),),
                    )
                ),
              ],
            ),
            Expanded(
              child: Text(widget.task.title),
            ),
            Flexible(
              child: Text(widget.task.snippet??"Пусто"),
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

  Widget _panel(context) => Column(
        children: <Widget>[
          _widgetName(context),
          _widgetGallery(),
          _widgetComments(),
        ],
      );
}
