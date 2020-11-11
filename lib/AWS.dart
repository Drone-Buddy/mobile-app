import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:geolocator/geolocator.dart';

class AWS {
  String websocketUrl =
      "wss://10eoew3urf.execute-api.us-east-1.amazonaws.com/development";
  var channel;
  StreamSubscription<Position> positionStream;
  bool isOpen = false;

  // AWS() {
  //   this.open();
  // }

  void open() {
    this.channel = IOWebSocketChannel.connect(websocketUrl);
    isOpen = true;
  }

  void close() {
    this.channel.sink.close(status.goingAway);
    isOpen = false;
  }

  void getStream() {
    return this.channel.sink.stream;
  }

  bool setUpGpsUpdater(String databaseHash) {
    if (databaseHash.length == 0) return false;
    this.positionStream =
        Geolocator.getPositionStream().listen((Position position) {
      this.sendGps(databaseHash, position);
    });
    return true;
  }

  void stopGpsUpdater() {
    if (!this.positionStream.isPaused) this.positionStream.pause();
  }

  void addUser(String databaseHash, String username, String gtid) {
    var jsonValue = {};
    jsonValue["action"] = "test";
    jsonValue["operation"] = "add user";
    jsonValue["database_hash"] = databaseHash;
    jsonValue["username"] = username;
    jsonValue["gtid"] = gtid;
    String jsonString = json.encode(jsonValue);
    this.open();
    this.channel.sink.add(jsonString);
  }

  String getGpsNmeaGPGGA() {
    String nmeaSentence = "\$GPGGA";

//     final DateTime utcTime = DateTime.now().toUtc();

//       double dd = 30.263888889;
//   print("dd: $dd");
//   int d = dd.toInt();
//   print("d: $d");
//   double mm = ((dd - d) * 60);
//   int m = mm.toInt();
//   print("m: $m");
//   double ss = (dd - d - m/60) * 3600;
//   int s = ss.toInt();
//   print("s: $ss");

//   dd = 40.003760;
//   print("dd: $dd");
//   d = dd.toInt();
//   print("d: $d");
//   mm = ((dd - d) * 60);
//   m = mm.toInt();
//   print("m: $m");
//   ss = (dd - d - m/60) * 3600;
//   s = ss.toInt();
//   print("s: $ss");

//   dd = -86.086818;
//   print("dd: $dd");
//   d = dd.toInt();
//   print("d: $d");
//   mm = ((dd - d) * 60);
//   m = mm.toInt();
//   print("m: $m");
//   ss = (dd - d - m/60) * 3600;
//   s = ss.toInt();
//   print("s: $ss");

//   String nmeaSentence = "\$GPGGA";
//   print(nmeaSentence);
// final DateTime now = DateTime.now().toUtc().add(new Duration(hours:10));
//     print(
//         "[${now.hour.toString().padLeft(2,'0')}${now.minute.toString().padLeft(2,'0')}${now.second.toString().padLeft(2,'0')}.00]");
  }

  void sendGps(String databaseHash, Position position) {
    var jsonValue = {};
    jsonValue["action"] = "test";
    jsonValue["operation"] = "set gps";
    jsonValue["id"] = databaseHash;
    jsonValue["type"] = "user";
    // jsonValue["gpsdata"] = position.toJson();

    var gpsValue = {};
    gpsValue["longitude"] = "" + position.longitude.toString();
    gpsValue["latitude"] = "" + position.latitude.toString();
    gpsValue["timestamp"] =
        "" + position.timestamp?.millisecondsSinceEpoch.toString();
    gpsValue["accuracy"] = "" + position.accuracy.toString();
    gpsValue["altitude"] = "" + position.altitude.toString();
    gpsValue["heading"] = "" + position.heading.toString();
    gpsValue["speed"] = "" + position.speed.toString();
    gpsValue["speed_accuracy"] = "" + position.speedAccuracy.toString();
    gpsValue["is_mocked"] = "" + position.isMocked.toString();

    jsonValue["gpsdata"] = gpsValue;

    String jsonString = json.encode(jsonValue);

    this.open();
    this.channel.sink.add(jsonString);

    final DateTime now = DateTime.now();
    print(
        "[${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}:${now.second}::${now.millisecond}] ==> ${json.encode(gpsValue)}"); // something like 2013-04-20
  }
}
