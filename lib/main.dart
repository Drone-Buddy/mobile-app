import 'package:flutter/material.dart';

void main() {
  runApp(DroneBuddyApp());
}

class DroneBuddyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drone Buddy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(title: 'Drone Buddy Home Page'),
    );
  }
}

String websocketUrl =
    "wss://10eoew3urf.execute-api.us-east-1.amazonaws.com/development";

class DroneObject {
  int id;
  double power;
  String firmware_version;
  int has_helped;
  DroneObject(this.id, this.power, this.firmware_version, this.has_helped);
}

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Below list for testing purposes.
    // TODO: Add WebSocket to AWS in order to get Drone Data and Supply GPS Data
    var available_drones = [
      DroneObject(0, 100, "0.0.0-alpha", 0),
      DroneObject(1, 34, "0.0.0-alpha", 0),
      DroneObject(2, 50.5, "0.0.0-alpha", 0),
      DroneObject(3, 32.6, "0.0.0-alpha", 0),
      DroneObject(4, 65.3, "0.0.0-alpha", 0),
      DroneObject(5, 87, "0.0.0-alpha", 0),
      DroneObject(6, 20, "0.0.0-alpha", 0),
      DroneObject(7, 100, "0.0.0-alpha", 0),
      DroneObject(0, 100, "0.0.0-alpha", 0),
      DroneObject(1, 34, "0.0.0-alpha", 0),
      DroneObject(2, 50.5, "0.0.0-alpha", 0),
      DroneObject(3, 32.6, "0.0.0-alpha", 0),
      DroneObject(4, 65.3, "0.0.0-alpha", 0),
      DroneObject(5, 87, "0.0.0-alpha", 0),
      DroneObject(6, 20, "0.0.0-alpha", 0),
      DroneObject(7, 100, "0.0.0-alpha", 0),
      DroneObject(0, 100, "0.0.0-alpha", 0),
      DroneObject(1, 34, "0.0.0-alpha", 0),
      DroneObject(2, 50.5, "0.0.0-alpha", 0),
      DroneObject(3, 32.6, "0.0.0-alpha", 0),
      DroneObject(4, 65.3, "0.0.0-alpha", 0),
      DroneObject(5, 87, "0.0.0-alpha", 0),
      DroneObject(6, 20, "0.0.0-alpha", 0),
      DroneObject(7, 100, "0.0.0-alpha", 0)
    ];

    var drones_list = <Widget>[];
    for (var i = 0; i < available_drones.length; i++) {
      drones_list.add(
        Column(
          children: <Widget>[
            RaisedButton(
              color: Colors.white,
              elevation: 1.0,
              padding: EdgeInsets.all(5.0),
              onPressed: () {
                print("Drone Selected");
                // eventTap(index[i], context);
              },
              child: Container(
                padding: EdgeInsets.all(16.0),
                // color: Colors.pink,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.075),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                "Drone #" + available_drones[i].id.toString(),
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold)))
                      ],
                    ),
                    Container(
                      height: 16.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Text("version: " +
                                available_drones[i]
                                    .firmware_version
                                    .toString()))
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Text("battery: " +
                                available_drones[i].power.toString() +
                                "%"))
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Text("has helped: " +
                                available_drones[i].has_helped.toString()))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Invoke "debug painting" (press "p" in the console, choose the
            // "Toggle Debug Paint" action from the Flutter Inspector in Android
            // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
            // to see the wireframe for each widget.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 15,
              ),
              Container(
                child: Text(
                  "Available Drones",
                  style: TextStyle(
                      fontSize: 35.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.black87),
                ),
                alignment: Alignment.topCenter,
              ),
              Container(
                height: 15.0,
              ),
              Expanded(child: ListView(children: drones_list)),
              Container(
                height: 15,
              ),
              RaisedButton(
                  onPressed: () {
                    print("CALL DRONE!");
                  },
                  child: Text("Call Closest Drone")),
              Container(
                height: 20,
              ),
            ],
          ),
        ));
  }
}
