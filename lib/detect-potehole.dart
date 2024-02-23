import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path/path.dart';
import 'package:road_app/model/potehole-model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sensors_plus/sensors_plus.dart';

class DetectPoteHole extends StatefulWidget {
  @override
  State<DetectPoteHole> createState() => _DetectPoteHoleState();
}

class _DetectPoteHoleState extends State<DetectPoteHole> {
  //variables
  late Database database;
  StreamSubscription? gyroSubscription;

  bool detectionStatus = false;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    initDb();
  }

  void initDb() async {
    print("called init detect");
    database = await openDatabase(
      join(await getDatabasesPath(), 'potehole.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE poteholes_location(id INTEGER PRIMARY KEY, lat TEXT, long TEXT)',
        );
      },
      version: 1,
    );
  }

  @override
  void dispose() {
    gyroSubscription?.cancel();
    gyroSubscription = null;
    super.dispose();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> insertPoteholeLocation(PoteHoleModel poteHoleModel) async {
    // await database.query( "INSERT OR REPLACE INTO poteholes_location (id, lat, long) values(0, ${poteHoleModel.lat}, ${poteHoleModel.long});");
    print("saved this");
    await database.insert(
      'poteholes_location',
      poteHoleModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  proccessDetection() async {
    print(detectionStatus);

    var lastVal = 0.0;
    if (detectionStatus) {
      gyroSubscription =
          accelerometerEvents.listen((AccelerometerEvent event) async {
        var ax = event.x;
        var ay = event.y;
        var az = event.z;
        print("z axis daat");
        print(az);
        if (az > lastVal) {
          print("got here");
          if (az > 2.2) {
            var locationData = await _determinePosition();
            await insertPoteholeLocation(PoteHoleModel(
                id: 0,
                lat: locationData.latitude.toString(),
                long: locationData.longitude.toString()));
          }

          lastVal = az;
        }
      });
      print("Started");
    } else {
      print("stopped");
      gyroSubscription?.cancel();
      gyroSubscription = null;
    }
  }

  handleDetectionProcess(status) {
    print("handle status");
    print(status);
    setState(() {
      detectionStatus = status;
    });
    proccessDetection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detect"),
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: new Color(0xff622f74),
              gradient: LinearGradient(
                colors: [new Color(0xff0F2027), new Color(0xff203A43)],
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  detectionStatus
                      ? handleDetectionProcess(false)
                      : handleDetectionProcess(true);
                },
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 75.0,
                  child: detectionStatus
                      ? Icon(
                          Icons.stop,
                          color: new Color(0xff0F2027),
                          size: 50.0,
                        )
                      : Icon(
                          Icons.play_arrow,
                          color: new Color(0xff0F2027),
                          size: 50.0,
                        ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 15.0),
              ),
              const Text(
                "Start/Stop Detection",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
