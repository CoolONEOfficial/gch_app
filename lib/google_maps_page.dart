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
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        StreamBuilder(
            stream: taskBloc.stream,
            builder: (context, snapshot) => GoogleMap(
              onTap: _onTap,
              onCameraMove: _onCameraMove,
              markers: _markers,
              mapType: MapType.normal,
              initialCameraPosition: NNov,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);

                //controller.onMarkerTapped.add(_onMarkerTap(task));
              },
            )),
        StreamBuilder(
          initialData: MyTask(),
          stream: taskBloc.stream,
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

class MyTask {
  MyTask();

  MyTask.defaultClass(this.id, this.position, this.title, this.snippet);

  //MyTask(this.id, this.position, this.title, this.snippet);

  bool isGood = false;
  String title = 'default title';
  String snippet = 'default snippet';
  String id = '1234567890';

  LatLng position = LatLng(56.327752241668215, 44.00208346545696);

  Marker toMarker (){
    var myDescriptor =
    BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);

    if (this is GoodTask) {
      myDescriptor =
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    } else if (this is BadTask) {
      myDescriptor = BitmapDescriptor.defaultMarker;
    }

    _markers.add(Marker(
        markerId: MarkerId(this.id),
        position: this.position,
        onTap: () => _onMarkerTap(this),
        icon: myDescriptor));
  }
}

_onMarkerTap(MyTask task) {
  taskBloc.add(task);
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
