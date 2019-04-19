import 'package:flutter/material.dart';
import 'package:gch_cityservice/google_maps_page.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class BottomDrawerCard extends StatelessWidget {

  //BottomDrawerCard();

  MyTask task;

  BottomDrawerCard(this.task);

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      panel: Card(
          child: Text(task.title),
      ),
    );
  }

}