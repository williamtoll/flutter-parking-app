import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:melb_car_park_app/rest/api_sdk.dart';

import 'Parking.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Future<Parking> _futureParking = Future.value(Parking(records: []));

  List<Marker> allMarkers = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      getData("", "").then((value) => {
            for (Records record in value.records)
              {
                if (record.geometry != null)
                  {
                    allMarkers.add(Marker(
                        point: LatLng(
                          record.fields.latitude,
                          record.fields.longitude,
                        ),
                        builder: (context) => const Icon(
                              Icons.location_pin,
                              color: Colors.red,
                              size: 30,
                            )))
                  }
              }
          });
      setState(() {});
    });
  }

  Future<Parking> getData(String query, String available) async {
    Map<String, dynamic> jsonData =
        await ApiSdk.fetchParkingList(query, available);

    setState(() {
      _futureParking = Future.value(Parking.fromJson(jsonData));
    });
    return _futureParking;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Parking Melbourne')),
      body: Column(
        children: [
          Flexible(
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(-37.8048962, 144.9486557),
                zoom: 13,
                maxZoom: 19.0,
                interactiveFlags: InteractiveFlag.all - InteractiveFlag.rotate,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                MarkerLayer(
                    markers:
                        allMarkers.sublist(0, min(allMarkers.length, 500))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
