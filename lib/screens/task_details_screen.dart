import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gch_cityservice/screens/home_screen.dart';
import 'package:gch_cityservice/task_details.dart';

class TaskDetailsScreen extends StatelessWidget {
  final MyTask task;

  const TaskDetailsScreen({Key key, this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(task.title),
    ),
    body: TaskDetails(task),
    );
    }


}