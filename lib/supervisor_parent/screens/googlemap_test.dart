import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapWidget extends StatefulWidget {
  @override
  _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  Map<PolylineId, Polyline> _mapPolylines = {};
  int _polylineIdCounter = 1;
  late GoogleMapController _mapController;

  void _addPolyline() {
    final String polylineIdVal = 'polyline_id_$_polylineIdCounter';
    _polylineIdCounter++;
    final PolylineId polylineId = PolylineId(polylineIdVal);

    final Polyline polyline = Polyline(
      polylineId: polylineId,
      consumeTapEvents: true,
      color: Colors.red,
      width: 5,
      points: _createPoints(),
    );

    setState(() {
      _mapPolylines[polylineId] = polyline;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Maps"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addPolyline,
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(target: LatLng(0, 0), zoom: 4.0),
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        polylines: Set<Polyline>.of(_mapPolylines.values),
      ),
    );
  }

  List<LatLng> _createPoints() {
    final List<LatLng> points = <LatLng>[];
    points.add(LatLng(1.875249, 0.845140));
    points.add(LatLng(30.851221, 1.715736));
    points.add(LatLng(8.196142, 2.094979));
    points.add(LatLng(12.196142, 3.094979));
    points.add(LatLng(16.196142, 40.094979));
    points.add(LatLng(20.196142, 5.094979));
    return points;
  }
}