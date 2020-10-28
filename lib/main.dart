import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:math';

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
  bool userInfoAvailable = false;

  bool nameError = false;
  String name = "";
  bool gtidError = false;
  int gtid = 0;
  String database_hash = null;

  final _nameFormFieldController = TextEditingController();
  final _gtidFormFieldController = TextEditingController();

  void _callDrone() {
    if (userInfoAvailable == false) {
      userInfoAlertDialog();
    } else {
      // TODO: Access Database to Call Drone

    }
  }

  Future<void> userInfoAlertDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Set Up Account"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  nameFormField(context),
                  gtidFormField(context)
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel", style: TextStyle(color: Colors.red)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Add"),
                onPressed: () {
                  print(
                      "nameError: $nameError && gtidError: $gtidError\nname: $name && gtid: $gtid");
                  if (!(nameError || gtidError)) {
                    _addUserInfo();
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          );
        });
  }

  _checkUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      gtid = prefs.getInt('gtid');
      name = prefs.getString('username');
      database_hash = prefs.getString('database_hash');
      if (gtid > 0 && name.length > 0 && database_hash.length > 0) {
        userInfoAvailable = true;
      } else {
        userInfoAvailable = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _checkUserInfo();

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
                      offset: Offset(0, 3), // change position of shadow
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

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
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
                    _callDrone();
                  },
                  child: Text("Call Closest Drone")),
              Container(
                height: 20,
              ),
            ],
          ),
        ));
  }

  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  String getRandomSaltString(int length) =>
      String.fromCharCodes(Iterable.generate(
          length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  _addUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('gtid', gtid);
    await prefs.setString('username', name);

    var saltString = getRandomSaltString(10) +
        name +
        getRandomSaltString(10) +
        gtid.toString() +
        getRandomSaltString(10);
    var bytes = utf8.encode(saltString);
    setState(() {
      database_hash = sha512.convert(bytes).toString();
    });

    await prefs.setString('database_hash', database_hash);
  }

  void test() {
    print("Name: $name");
  }

  TextField nameFormField(BuildContext context) {
    return TextField(
      controller: _nameFormFieldController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      onChanged: (text) {
        setState(() {
          print("nameFormField: $text");
          if (text.length == 0) {
            nameError = true;
          } else {
            nameError = false;
            name = text;
          }
        });
      },
      decoration: InputDecoration(
        hintText: "Full Name",
        // icon: Icon(Icons.person),
        fillColor: Colors.white,
        labelText: "Full Name",
        errorText: nameError ? "Please Enter Your Name" : null,
      ),
    );
  }

  String errorNameMessage() {
    if (nameError) {
      return "Please Enter Your Name";
    } else {
      return null;
    }
  }

  TextField gtidFormField(BuildContext context) {
    return TextField(
      controller: _gtidFormFieldController,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      onChanged: (text) {
        setState(() {
          print("gtidFormField: $text");
          if (text.length < 9) {
            gtidError = true;
          } else {
            gtidError = false;
            gtid = int.parse(text);
          }
        });
      },
      decoration: InputDecoration(
        hintText: "Gt Id",
        // icon: Icon(Icons.person),
        fillColor: Colors.white,
        labelText: "Gt Id",
        errorText: gtidError ? "Please Enter Your GTID" : null,
      ),
    );
  }

  String errorGtIdMessage() {
    if (gtidError) {
      return "Please Enter Your GTID";
    } else {
      return null;
    }
  }
}
