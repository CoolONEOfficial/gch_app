import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gch_cityservice/bottom_drawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//final Set<Marker> _markers = {};
Set<Marker> _markers = {};

class MyMapWidget extends StatefulWidget {
  @override
  State<MyMapWidget> createState() => MyMapWidgetState();
}

class MyMapWidgetState extends State<MyMapWidget> {
  Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition NNov = const CameraPosition(
    target: LatLng(56.327752241668215, 44.00208346545696),
    zoom: 14,
  );

  CameraPosition _lastCameraPosition = NNov;

  void _onCameraMove(CameraPosition position) {
    _lastCameraPosition = position;
  }

  Widget bottomDrawerPanel = BottomDrawerCard(MyTask());

  @override
  void initState() {
    super.initState();
    getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: Text("Task Map"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.update),
            onPressed: ()=>getTasks(),
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onTap: _onTap,
            onCameraMove: _onCameraMove,
            markers: _markers,
            mapType: MapType.normal,
            initialCameraPosition: NNov,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);

              //controller.onMarkerTapped.add(_onMarkerTap(task));
            },
          ),
          StreamBuilder(
            initialData: MyTask(),
            stream: taskBloc.stream,
            builder: (context, snapshot) => BottomDrawerCard(snapshot.data),
          ),
        ],
      ),
//      floatingActionButton: FloatingActionButton.extended(
//        onPressed: _onAddMarkerButtonPressed,
//        label: Text('Add marker!'),
//        icon: const Icon(
//          Icons.add_location,
//          size: 36.0,
//        ), //Icon(Icons.directions_boat),
//      ),
    );
  }

  Future<void> _onTap(LatLng tapPos) async {
    final CameraPosition newPos = CameraPosition(
      target: tapPos,
      zoom: _lastCameraPosition.zoom,
      bearing: _lastCameraPosition.bearing,
      tilt: _lastCameraPosition.tilt,
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(newPos));
  }

//  void _onAddMarkerButtonPressed() {
//    setState(() {
//      _markers.add(Marker(
//        // This marker id can be anything that uniquely identifies each marker.
//        markerId: MarkerId(_lastCameraPosition.target.toString()),
//        position: _lastCameraPosition.target,
//        infoWindow: InfoWindow(
//          title: 'One nore issue',
//          snippet: '3 people signed',
//        ),
//        icon: BitmapDescriptor.defaultMarker,
//      ));
//    });
//  }

  _onMarkerTap(MyTask task) {
    taskBloc.add(task);
  }

  void getTasks() {
    Set<MyTask> fetchedTasks = Set<MyTask>();

    LatLng position1 = LatLng(56.327752241668215, 44.00208346545696);
    LatLng position2 = LatLng(56.337752241668215, 44.00208346545696);

    fetchedTasks
        .add(MyTask.defaultClass('1234', position1, 'title', 'snippet'));
    fetchedTasks
        .add(MyTask.defaultClass('5678', position2, 'TITLE', 'lil snippet'));

    setState(() {
      //_markers.clear();
      for (var task in fetchedTasks) {
        var myDescriptor =
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);

        if (task is GoodTask) {
          myDescriptor =
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
        } else if (task is BadTask) {
          myDescriptor = BitmapDescriptor.defaultMarker;
        }

        _markers.add(Marker(
            markerId: MarkerId(task.id),
            position: task.position,
            infoWindow: InfoWindow(
              title: task.title,
              snippet: task.snippet,
            ),
            onTap: () => _onMarkerTap(task),
            icon: myDescriptor
//          icon: BitmapDescriptor.defaultMarker,
            ));
      }
    });
  }
}

class MyTask {
  MyTask();

  MyTask.defaultClass(this.id, this.position, this.title, this.snippet);

  //MyTask(this.id, this.position, this.title, this.snippet);

  bool isGood = false;
  String title = 'default title';
  String snippet = 'default snippet';
  String id = '1234567890';

  LatLng position = LatLng(56.327752241668215, 44.00208346545696);
}

class GoodTask extends MyTask {
  GoodTask(String id, LatLng position, String title, String snippet)
      : super.defaultClass(id, position, title, snippet);
}

class BadTask extends MyTask {
  BadTask(String id, LatLng position, String title, String snippet)
      : super.defaultClass(id, position, title, snippet);
}

final taskBloc = StreamController<MyTask>.broadcast();
