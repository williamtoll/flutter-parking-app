import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:melb_car_park_app/favourites/Favourites.dart';
import 'package:melb_car_park_app/parking/Parking.dart';
import 'package:melb_car_park_app/parking/ParkingDetail.dart';
import 'package:melb_car_park_app/parking/ParkingListPage.dart';
import 'package:provider/provider.dart';

import 'parking/MapPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Melbourne Car Park App',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
          ),
          home: const MyHomePage(title: 'Melbourne Car Park')),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var selectedIndex = 0;

  Records selectedLocation = Records(
      datasetid: "",
      recordid: "",
      fields: Fields(latitude: 0, longitude: 0),
      geometry: Geometry(null),
      recordTimestamp: "");

  var current = [];

  List<Records> favorites = [];

  void getNext() {
    notifyListeners();
  }

  void goToPage(int page) {
    selectedIndex = page;
    notifyListeners();
  }

  void toggleFavorite(Records record) {
    if (favorites
        .where((element) => element.recordid == record.recordid)
        .isNotEmpty) {
      favorites.removeWhere((element) => element.recordid == record.recordid);
    } else {
      favorites.add(record);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    Widget page;

    var appState = context.watch<MyAppState>();

    switch (appState.selectedIndex) {
      case 0:
        page = ParkingListPage();
        break;
      case 1:
        page = MapPage();
        break;
      case 2:
        page = FavoritesPage();
        break;
      case 3:
        page = ParkingDetailPage();
        break;
      default:
        throw UnimplementedError('no widget for ${appState.selectedIndex}');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Parking'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.map),
                    label: Text('Map'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite),
                    label: Text('Favorites'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.details),
                    label: Text(''),
                  )
                ],
                selectedIndex: appState.selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    appState.selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}
