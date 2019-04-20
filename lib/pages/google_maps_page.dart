import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gch_cityservice/bottom_drawer.dart';
import 'package:gch_cityservice/main.dart';
import 'package:gch_cityservice/screens/home_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        StreamBuilder<Set<MyTask>>(
            stream: taskBloc.stream,
            builder: (context, snapshot) => GoogleMap(
                  onTap: _onTap,
                  onCameraMove: _onCameraMove,
                  markers: snapshot.data
                          ?.map(
                            (task) => task.toMarker(),
                          )
                          ?.toSet() ??
                      Set(),
                  mapType: MapType.normal,
                  initialCameraPosition: NNov,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                )),
        StreamBuilder(
          initialData: MyTask(),
          stream: bottomCardBloc.stream,
          builder: (context, snapshot) => BottomDrawerCard(snapshot.data),
        ),
      ],
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
}

onMarkerTap(MyTask task) {
  bottomCardBloc.add(task);
}

class GoodTask extends MyTask {
  GoodTask(String id, LatLng position, String title, String snippet)
      : super.defaultClass(id, position, title, snippet);
}

class BadTask extends MyTask {
  BadTask(String id, LatLng position, String title, String snippet)
      : super.defaultClass(id, position, title, snippet);
}

final bottomCardBloc = StreamController<MyTask>.broadcast();

AppBar myMapAppBar(){
  return AppBar(
    title: Text("MyMap"),
  );
}