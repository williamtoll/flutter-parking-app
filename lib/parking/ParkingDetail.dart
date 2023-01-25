import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'Parking.dart';

class ParkingDetailPage extends StatefulWidget {
  const ParkingDetailPage({Key? key}) : super(key: key);

  @override
  _ParkingDetailPageState createState() => _ParkingDetailPageState();
}

class _ParkingDetailPageState extends State<ParkingDetailPage> {
  List<Marker> allMarkers = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    Records record = appState.selectedLocation;

    allMarkers.add(Marker(
        point: LatLng(
          record.fields.latitude,
          record.fields.longitude,
        ),
        builder: (context) => const Icon(
              Icons.location_pin,
              color: Colors.red,
              size: 30,
            )));

    print(allMarkers);

    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                appState.goToPage(0);
              },
              icon: Icon(Icons.arrow_back_ios),
            ),
            title: Text('')),
        body: Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Container(
                  child: Column(
                children: [
                  Text('${record.fields.meterid}'),
                  Text('${record.fields.streetname}'),
                  Row(children: [
                    Icon(
                      record.fields!.tapandgo == 'YES'
                          ? Icons.local_parking
                          : Icons.cancel_outlined,
                      color: Colors.blue[500],
                    ),
                    SizedBox(width: 10),
                    Text(record.fields!.tapandgo == 'YES'
                        ? "Parking Available"
                        : "Parking Unavailable")
                  ]),
                  Row(children: [
                    Icon(
                      record.fields.creditcard == 'YES'
                          ? Icons.credit_card
                          : Icons.credit_card_off,
                      color: Colors.blue[500],
                    ),
                    SizedBox(width: 10),
                    Text(record.fields!.creditcard == 'YES'
                        ? "Credit card Payment available"
                        : "Cash only")
                  ])
                ],
              )),
              Flexible(
                child: FlutterMap(
                  options: MapOptions(
                    center: LatLng(-37.8048962, 144.9486557),
                    zoom: 13,
                    maxZoom: 19.0,
                    interactiveFlags:
                        InteractiveFlag.all - InteractiveFlag.rotate,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    ),
                    MarkerLayer(markers: allMarkers),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
