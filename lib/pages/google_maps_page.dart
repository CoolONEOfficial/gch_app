import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gch_cityservice/task_details.dart';
import 'package:gch_cityservice/screens/home_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';
import 'package:sliding_up_panel/sliding_up_panel.dart';

double panelHeightClosed = 95;

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

  double bordersRadius = 0;

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
          stream: bottomCardBloc.stream,
          builder: (context, snapshot) => snapshot.data != null
              ? SlidingUpPanel(
                  maxHeight: ScreenUtil.getInstance().setHeight(1750),
                  minHeight: panelHeightClosed,
                  parallaxEnabled: true,
                  backdropEnabled: true,
                  parallaxOffset: .5,
                  panel: TaskDetails(snapshot.data),
                  onPanelSlide: (pos) {
                    setState(() {
                      bordersRadius = pos;
                    });
                  },
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular((1 - bordersRadius) * 20),
                    topRight: Radius.circular((1 - bordersRadius) * 20),
                  ),
                )
              : Container(),
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

AppBar myMapAppBar() {
  return AppBar(
    title: Text("Карта"),
  );
}

LatLng lastPosition = LatLng(56.327752241668215, 44.00208346545696);

double toRadians(double z) {
  return z * pi / 180;
}
