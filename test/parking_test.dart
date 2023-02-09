import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:melb_car_park_app/Parking/ParkingListPage.dart';
import 'package:melb_car_park_app/parking/Parking.dart';
import 'package:melb_car_park_app/rest/api_sdk.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

class ApiSdkMock extends Mock implements ApiSdk {
  Future<Parking> fetchParkingList(String search, String availability) async =>
      Parking.fromJson({
        "nhits": 994,
        "parameters": {
          "dataset": "on-street-car-parking-meters-with-location",
          "rows": 1,
          "start": 0,
          "facet": ["creditcard", "tapandgo", "streetname"],
          "format": "json",
          "timezone": "UTC"
        },
        "records": [
          {
            "datasetid": "on-street-car-parking-meters-with-location",
            "recordid": "07565a4a679bed215f4f9cb132dd3f5ec912d986",
            "fields": {
              "location": [-37.783329250579456, 144.95481692769565],
              "meterid": "ZOOT12",
              "assetid": "1629635",
              "metertype": "Cale CWT-C",
              "barcode": "MPM1629635",
              "latitude": -37.783329250579456,
              "longitude": 144.95481692769565,
              "creditcard": "YES",
              "streetname": "Poplar Road",
              "tapandgo": "YES"
            },
            "geometry": {
              "type": "Point",
              "coordinates": [144.95481692769565, -37.783329250579456]
            },
            "record_timestamp": "2022-12-15T16:15:00.687Z"
          }
        ],
        "facet_groups": [
          {
            "name": "creditcard",
            "facets": [
              {"name": "YES", "count": 994, "state": "displayed", "path": "YES"}
            ]
          },
          {
            "name": "tapandgo",
            "facets": [
              {
                "name": "YES",
                "count": 901,
                "state": "displayed",
                "path": "YES"
              },
              {"name": "NO", "count": 93, "state": "displayed", "path": "NO"}
            ]
          },
          {"name": "streetname", "facets": []}
        ]
      });
}

class ParkingListPageMock extends Mock implements ParkingListPage {
  late BuildContext context;
  String toString({DiagnosticLevel? minLevel}) => 'ParkingListPageMock';
}

class ParkingListStateMock extends Mock implements ParkingListState {
  late BuildContext context;
  String toString({DiagnosticLevel? minLevel}) => 'ParkingListPageMock';
}

@GenerateMocks([http.Client])
void main() {
  final apiSdkMock = ApiSdkMock();

  test('check the fetch parking list feature, get data from the API', () async {
    expect(await apiSdkMock.fetchParkingList('', ''), isA<Parking>());

    final parkingData = await apiSdkMock.fetchParkingList('', '');
    expect(parkingData.records.length, 1);
    expect(parkingData.records[0].fields.streetname, 'Poplar Road');
  });
}
