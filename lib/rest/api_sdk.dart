import 'dart:convert';

import 'package:melb_car_park_app/rest/api_handler.dart';

class ApiSdk {
  static fetchParkingList(String streetName, String available) async {
    String path =
        "/records/1.0/search/?dataset=on-street-car-parking-meters-with-location&rows=20&facet=creditcard&facet=tapandgo&facet=streetname";
    if (streetName != "") {
      path = "$path&q=$streetName";
    }

    if (available != "") {
      path = "$path&refine.tapandgo=$available";
    }

    return await ApiHandler.getData(path);
  }
}
