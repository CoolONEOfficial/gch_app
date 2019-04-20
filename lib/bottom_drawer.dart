import 'package:flutter/material.dart';
import 'package:gch_cityservice/google_maps_page.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class BottomDrawerCard extends StatelessWidget {

  //BottomDrawerCard();

  MyTask task;

  BottomDrawerCard(this.task);

//  final double _initFabHeight = 120.0;
////  double _fabHeight;
  double _panelHeightOpen = 575.0;
  double _panelHeightClosed = 95.0;

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      maxHeight: _panelHeightOpen,
      minHeight: _panelHeightClosed,
      parallaxEnabled: true,
      parallaxOffset: .5,
      panel: _panel(),
      borderRadius: BorderRadius.only(topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
//      onPanelSlide: (double pos) => setState((){
//        _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) + _initFabHeight;
//      }),
    );
  }

  Widget _widgetName(){
    return Text("yaya");
  }

  Widget _widgetGallery(){
    return Text("yaya");
  }

  Widget _widgetComments(){
    return ListView(
      children: <Widget>[
        Text('comment 1'),
        Text('comment 2'),
        Text('comment 3')
      ],
    );
  }

  Widget _panel(){
    return Column(
      children: <Widget>[
        _widgetName(),
        _widgetGallery(),
        _widgetComments()
      ],
    );
  }

}