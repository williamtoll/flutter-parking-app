import 'package:flutter/material.dart';
import 'package:melb_car_park_app/parking/Parking.dart';
import 'package:melb_car_park_app/rest/api_sdk.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../main.dart';

class ParkingListPage extends StatefulWidget {
  const ParkingListPage({super.key});

  @override
  State<ParkingListPage> createState() => ParkingListState();
}

class ParkingListState extends State<ParkingListPage> {
  Future<Parking> futureParking = Future.value(Parking(records: []));

  @override
  void initState() {
    super.initState();
    getData("", "");
  }

  void getData(String query, String available) async {
    Map<String, dynamic> jsonData =
        await ApiSdk.fetchParkingList(query, available);
    setState(() {
      futureParking = Future.value(Parking.fromJson(jsonData));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parking available',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text('Melbourne Car Park list'),
          actions: [
            IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(),
                );
              },
              icon: const Icon(Icons.search),
            ),
            IconButton(
              icon: Icon(
                Icons.filter_list,
              ),
              onPressed: () {
                showFilterDialog(context);
              },
            ),
          ],
        ),
        body: Center(
          child: FutureBuilder<Parking>(
            future: futureParking,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.records.length > 0) {
                return Container(
                  child: ListView.builder(
                      itemCount: snapshot.data!.records.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _buildParkingRow(
                            snapshot.data!.records[index], context);
                      }),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }

  Future<void> showFilterDialog(BuildContext context) {
    bool isCheckedAvailable = false;
    bool isCheckUnavailable = false;
    return showDialog(
        context: context,
        builder: (BuildContext build) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                title: Center(
              child: Container(
                  child: Column(children: [
                CheckboxListTile(
                  checkColor: Colors.white,
                  value: isCheckedAvailable,
                  title: const Text('Available'),
                  onChanged: (bool? value) {
                    setState(() {
                      isCheckedAvailable = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  checkColor: Colors.white,
                  value: isCheckUnavailable,
                  title: const Text('Unavailable'),
                  onChanged: (bool? value) {
                    setState(() {
                      isCheckUnavailable = value!;
                    });
                  },
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    if ((isCheckedAvailable && isCheckUnavailable) ||
                        (!isCheckedAvailable && !isCheckUnavailable)) {
                      getData("", "");
                    } else if (isCheckedAvailable) {
                      getData("", "YES");
                    } else if (isCheckUnavailable) {
                      getData("", "NO");
                    }

                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.done),
                  label: Text('OK'),
                )
              ])),
            ));
          });
        });
  }
}

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          close(context, "");
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    Future<Parking> future = getData(query, "");

    // close(context, null);

    return Center(
      child: FutureBuilder<Parking>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.records.length > 0) {
            return Container(
              child: ListView.builder(
                  itemCount: snapshot.data!.records.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildParkingRow(
                        snapshot.data!.records[index], context);
                  }),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
    );
  }

  Future<Parking> getData(String query, String available) async {
    Map<String, dynamic> jsonData =
        await ApiSdk.fetchParkingList(query, available);
    return Future.value(Parking.fromJson(jsonData));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    Future<Parking> suggestionList = getData(query, "");

    return Center(
      child: FutureBuilder<Parking>(
        future: suggestionList,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.records.length > 0) {
            return Container(
              child: ListView.builder(
                  itemCount: snapshot.data!.records.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildParkingRow(
                        snapshot.data!.records[index], context);
                  }),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

Widget _buildParkingRow(Records record, BuildContext context) {
  var appState = context.watch<MyAppState>();
  return Container(
      height: 60,
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      color: Colors.amber[50],
      child: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: Column(
            children: [
              Text('${record.fields.streetname}'),
              Container(
                  child: Row(children: [
                Icon(
                  record.fields!.tapandgo == 'YES'
                      ? Icons.local_parking
                      : Icons.cancel_outlined,
                  color: Colors.blue[500],
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  record.fields.creditcard == 'YES'
                      ? Icons.credit_card
                      : Icons.credit_card_off,
                  color: Colors.blue[500],
                )
                // ]),
              ])),
            ],
          )),
          ElevatedButton.icon(
            onPressed: () {
              appState.toggleFavorite(record);
            },
            icon: Icon(Icons.favorite),
            label: Text("Like"),
          ),
          SizedBox(
            width: 10,
          ),
          ElevatedButton.icon(
            onPressed: () {
              // Detail page code is 3
              appState.selectedLocation = record;
              appState.goToPage(3);
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.directions),
            label: Text("Detail"),
          )
        ],
      )));
}
