import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//final Set<Marker> _markers = {};
Set<Marker> _markers = {};

class myMapWidget extends StatefulWidget {
  @override
  State<myMapWidget> createState() => myMapWidgetState();
}

class myMapWidgetState extends State<myMapWidget> {
  Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition NNov = const CameraPosition(
    target: LatLng(56.327752241668215, 44.00208346545696),
    zoom: 14,
  );

  CameraPosition _lastCameraPosition = NNov;

  void _onCameraMove(CameraPosition position) {
    _lastCameraPosition = position;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        onTap: _onTap,
        onCameraMove: _onCameraMove,
        markers: _markers,
        mapType: MapType.normal,
        initialCameraPosition: NNov,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onAddMarkerButtonPressed,
        label: Text('Add marker!'),
        icon: const Icon(Icons.add_location, size: 36.0),//Icon(Icons.directions_boat),
      ),
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

  void _onAddMarkerButtonPressed() {


    var myDescriptor = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);

    bool ifGreen = false;

    if(ifGreen){
      myDescriptor = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    } else {
      myDescriptor = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    }

    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastCameraPosition.target.toString()),
        position: _lastCameraPosition.target,
        infoWindow: InfoWindow(
          title: 'One nore issue',
          snippet: '3 people signed',
        ),
        icon: myDescriptor,
      ));
    });
  }

  Future<void> getMarkers() async {
    //TODO get rest markers then setState(){}
    //getMarker
//    Set<Marker> gotMarkers;
//
//    setState(() {
//      _markers.clear();
//      for(var marker in gotMarkers){
//        _markers.add(Marker(
//          // This marker id can be anything that uniquely identifies each marker.
//          markerId: MarkerId(marker.id.toString()),
//          position: marker.position,
//          infoWindow: InfoWindow(
//            title: 'Really cool place',
//            snippet: '5 Star Rating',
//          ),
//          icon: BitmapDescriptor.defaultMarker
////          icon: BitmapDescriptor.defaultMarker,
//        ));
//      };
//    });
//
//    print("");
  }

//  void printPosition() {
//    print(_lastMapPosition);
//  }


}
