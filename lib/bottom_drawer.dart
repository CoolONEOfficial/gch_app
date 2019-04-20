import 'package:flutter/material.dart';
import 'package:gch_cityservice/google_maps_page.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class BottomDrawerCard extends StatelessWidget {

  MyTask task;

  BottomDrawerCard(this.task);

//  final double _initFabHeight = 120.0;
////  double _fabHeight;
  double _panelHeightOpen = 400.0;
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
          topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
//      onPanelSlide: (double pos) => setState((){
//        _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) + _initFabHeight;
//      }),wds
    );
  }

  Widget _widgetName() {
    return Container(
        height: _panelHeightClosed,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(task.title),
            ),
            Flexible(
              child: Text(task.snippet),
            )
          ],
        ));
  }

  Widget _widgetGallery() {
    return Flexible(
      child: ListView(
        // This next line does the trick.
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Container(
            width: 160.0,
            color: Colors.red,
          ),
          Container(
            width: 160.0,
            color: Colors.blue,
          ),
          Container(
            width: 160.0,
            color: Colors.green,
          ),
          Container(
            width: 160.0,
            color: Colors.yellow,
          ),
          Container(
            width: 160.0,
            color: Colors.orange,
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
          leading: const Icon(Icons.event_seat),
          title: const Text('The seat for the narrator'),
        ),
        ListTile(
          leading: const Icon(Icons.event_seat),
          title: const Text('The seat for the narrator'),
        ),
        ListTile(
          leading: const Icon(Icons.event_seat),
          title: const Text('The seat for the narrator'),
        ),
        ListTile(
          leading: const Icon(Icons.event_seat),
          title: const Text('The seat for the narrator'),
        ),
        ListTile(
          leading: const Icon(Icons.event_seat),
          title: const Text('The seat for the narrator'),
        ),
        ListTile(
          leading: const Icon(Icons.event_seat),
          title: const Text('The seat for the narrator'),
        ),
        ListTile(
          leading: const Icon(Icons.event_seat),
          title: const Text('The seat for the narrator'),
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
