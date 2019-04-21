import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gch_cityservice/bottom_drawer.dart';
import 'package:gch_cityservice/screens/home_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';

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
        StreamBuilder(
            stream: taskBloc.stream,
            builder: (context, snapshot) => GoogleMap(
                  onTap: _onTap,
                  onCameraMove: _onCameraMove,
                  markers: tasksSet
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

final bottomCardBloc = StreamController<MyTask>.broadcast();

AppBar myMapAppBar(){
  return AppBar(
    title: Text("MyMap"),
  );
}

LatLng lastPosition;

///in meters
int calcDistance(LatLng from, LatLng to){
  final double EARTH_RADIUS = 6371009;
  double res = acos(sin(toRadians(from.latitude) * sin(toRadians(to.latitude))) + cos(toRadians(from.latitude))*cos(toRadians(to.latitude))*cos(toRadians(from.longitude-to.longitude))) * EARTH_RADIUS;
  return res.round();
}

double toRadians(double z){
  return z*pi/180;
}