import 'package:flutter/material.dart';
import 'package:road_app/detect-potehole.dart';
import 'package:road_app/show-potholes.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Home'),
    );
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(25, 100, 25, 25),
          child: Center(
            child: Column(
              children: <Widget>[
                Image.asset(
                  'assets/img/illustration.png',
                  width: 300,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 50),
                ),
                Text(
                  'Road Condition',
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Monitoring System'.toUpperCase(),
                  style: TextStyle(
                    fontSize: 48,
                    color: Theme.of(context).primaryColor,
                    fontFamily: 'Bebas',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 30),
                ),
                const Text(
                  'Road anomalies like patching, bumps, cracking, potholes and small defects on the surface can be used to characterize the quality of the road surface.',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 30),
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetectPoteHole(),
                      ),
                    );
                  },
                  minWidth: double.infinity,
                  height: 50,
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  child: Text(
                    'Start Detection'.toUpperCase(),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShowPoteHoles(),
                      ),
                    );
                  },
                  minWidth: double.infinity,
                  height: 50,
                  textColor: Theme.of(context).primaryColor,
                  child: Text(
                    'View Map'.toUpperCase(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
