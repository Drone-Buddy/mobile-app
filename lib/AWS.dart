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

  String decimalToDegrees(double pos) {
    pos = pos.abs();
    double dd = pos;
    int d = dd.toInt();
    double mm = ((dd - d) * 60);
    String degrees = d.toStringAsFixed(0).padLeft(2, '0');
    if (mm < 10) {
      degrees += "0";
    }
    degrees += mm.toString();
    print(
        "d => ${d.toString().padLeft(2, '0')}  &&  mm => ${mm < 10 ? "0" + mm.toString() : mm.toString()}");
    return degrees;
  }

  String latitudeToDegrees(double latitude) {
    String isNorth = "N";
    if (latitude < 0) isNorth = "S";
    return decimalToDegrees(latitude) + "," + isNorth;
  }

  String longitudeToDegrees(double longitude) {
    String isEast = "E";
    if (longitude < 0) isEast = "W";
    return decimalToDegrees(longitude) + "," + isEast;
  }

  String getGpsNmeaGPGGA(Position position) {
    String nmeaSentence = "GPGGA";
    final DateTime now = DateTime.now().toUtc().add(new Duration(hours: 10));
    nmeaSentence += "," +
        "${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}.00";

    nmeaSentence += "," + latitudeToDegrees(position.latitude);
    nmeaSentence += "," + longitudeToDegrees(position.longitude);

    nmeaSentence += "," + "1"; // GPS Quality indicator
    nmeaSentence += "," + "05"; // No. of Satelites
    nmeaSentence += "," + position.accuracy.toString(); // Accuracy --> HDOP
    nmeaSentence +=
        "," + position.altitude.toString() + ",M"; // Altitude with Units
    nmeaSentence += ","; // 	Geoid separation
    nmeaSentence += ","; //   M: geoid separation measured in meters
    nmeaSentence +=
        ","; //   Age of differential GPS data record, Type 1 or Type 9. Null field when DGPS is not used.
    nmeaSentence += ","; //   	Reference station ID, range 0000-4095.

    // Checksum calculation
    int checksum = 0;
    List bytes = utf8.encode(nmeaSentence);
    for (var i = 0; i < bytes.length; i++) {
      checksum ^= bytes[i];
    }
    checksum = checksum.toUnsigned(8);
    checksum &= 0x00FF; // MAKE SURE only 8 bits is used

    nmeaSentence += "*" +
        checksum
            .toRadixString(16)
            .toString()
            .padLeft(2, '0'); // Adding checksum

    nmeaSentence = "\$" + nmeaSentence;
    return nmeaSentence;
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
    gpsValue["nmea"] = getGpsNmeaGPGGA(position);
    jsonValue["gpsdata"] = gpsValue;

    String jsonString = json.encode(jsonValue);

    this.open();
    this.channel.sink.add(jsonString);

    final DateTime now = DateTime.now();
    print(
        "[${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}:${now.second}::${now.millisecond}] ==> ${json.encode(gpsValue)}"); // something like 2013-04-20
  }
}
