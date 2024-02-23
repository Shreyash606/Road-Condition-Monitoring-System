import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:path/path.dart';
import 'package:road_app/model/potehole-model.dart';
import 'package:sqflite/sqflite.dart';

class ShowPoteHoles extends StatefulWidget {
  const ShowPoteHoles({super.key});

  @override
  State<ShowPoteHoles> createState() => _ShowPoteHolesState();
}

class _ShowPoteHolesState extends State<ShowPoteHoles> {
  @override
  Widget build(BuildContext context) {
    MapController mapController = MapController(
      initMapWithUserPosition: true,
    );

    late Database database;

    addMarker(lat, long) {
      print("addmarker");
      mapController.addMarker(
          GeoPoint(latitude: double.parse(lat), longitude: double.parse(long)),
          markerIcon: const MarkerIcon(
              icon: Icon(
            Icons.add,
            color: Colors.orange,
            size: 100,
          )));
    }

    Future<List<PoteHoleModel>> getPoteHoles() async {
      //print("called here");
      database = await openDatabase(
        join(await getDatabasesPath(), 'potehole.db'),
        // onCreate: (db, version) {
        //   return db.execute(
        //     'CREATE TABLE poteholes_location(id INTEGER PRIMARY KEY, lat TEXT, long TEXT)',
        //   );
        // },
        version: 1,
      );
      final List<Map<String, dynamic>> maps =
          await database.query('poteholes_location');
      //print(json.encode(maps));

      for (var element in maps) {
        addMarker(element['lat'], element['long']);
      }

      return List.generate(maps.length, (i) {
        return PoteHoleModel(
          id: maps[i]['id'],
          lat: maps[i]['lat'],
          long: maps[i]['long'],
        );
      });
    }

    @override
    void initState() {
      WidgetsFlutterBinding.ensureInitialized();
      getPoteHoles();
    }

    @override
    void dispose() {
      mapController.dispose();
      super.dispose();
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Poteholes"),
          centerTitle: true,
        ),
        body: OSMFlutter(
          controller: mapController,
          trackMyPosition: true,
          initZoom: 12,
          minZoomLevel: 8,
          maxZoomLevel: 14,
          stepZoom: 1.0,
          userLocationMarker: UserLocationMaker(
            personMarker: const MarkerIcon(
              icon: Icon(
                Icons.location_history_rounded,
                color: Colors.red,
                size: 48,
              ),
            ),
            directionArrowMarker: const MarkerIcon(
              icon: Icon(
                Icons.double_arrow,
                size: 48,
              ),
            ),
          ),
          roadConfiguration: RoadConfiguration(
            startIcon: const MarkerIcon(
              icon: Icon(
                Icons.person,
                size: 64,
                color: Colors.brown,
              ),
            ),
            roadColor: Colors.yellowAccent,
          ),
          markerOption: MarkerOption(
              defaultMarker: const MarkerIcon(
            icon: Icon(
              Icons.person_pin_circle,
              color: Colors.blue,
              size: 56,
            ),
          )),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (() async {
            await getPoteHoles();
          }),
          child: Icon(Icons.remove_red_eye),
        ));
  }
}
