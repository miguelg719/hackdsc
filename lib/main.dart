import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocation/geolocation.dart';


void main() => runApp(MyApp());


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GoogleMapController controller;
  final Map<String, Marker> _markers = {};

  getPermission() async {
    final GeolocationResult result = await Geolocation.isLocationOperational();
    return result;
  }

  getLocation() {
    return getPermission().then((result) async{
        if(result.isSuccessful) {
          StreamSubscription<LocationResult> subscription = Geolocation.currentLocation(accuracy: LocationAccuracy.best).listen((result) {
            var latitude = result.location.latitude;
            var longitude = result.location.longitude;
          });
        }
    });
  }


  buildMap() {
    getLocation().then((response) {
        response.listen((value) {
          _markers.clear();
          final marker = Marker(
            markerId: MarkerId("Current Position"),
            position: LatLng(value.location.latitude, value.location.longitude),
            infoWindow: InfoWindow(
              title: value.location.latitude.toString(),
              snippet: value.location.latitude.toString(),
            ),
          );
          _markers["Current Location"] = marker;
        });
    });
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: const Text('POTENTIAL AREAS INFECTED',
                      style:  TextStyle(
                        color: Colors.orangeAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
        ),
        backgroundColor: Colors.redAccent[400],
      ),
      body: GoogleMap(
        onMapCreated: buildMap(),
        initialCameraPosition: CameraPosition(
          target: const LatLng(0, 0),
          zoom: 3,
        ),
        markers: _markers.values.toSet(),
      ),
    ),
  );
}