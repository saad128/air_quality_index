import 'dart:convert';

import 'package:air_quality_index/screens/locations.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  static const routeName = '/home';

  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};
  String? currentAddress;
  Position? currentPosition;
  int? airQualityIndex;
  String? dominentPoll;
  String? time;

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: 'Please keep your location on');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: 'Location Permission is denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(msg: 'Permission is denied Forever');
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      setState(() {
        currentAddress = '${place.locality},${place.country}';
      });
      String value = 'ad116a0c87bdf7ab17cac30c0aeec3817b9782ca';
      Response response = await get(Uri.parse('https://api.waqi'
          '.info/feed/geo:${position.latitude};${position.longitude}/?token=$value'));
      Map data = json.decode(response.body);
      //print(data);
      int airQuality = data['data']['aqi'];
      print(airQuality);
      String dominentPol = data['data']['dominentpol'];
      print(dominentPol);
      String timeZone = data['data']['time']['tz'].substring(1, 3);
      print(timeZone);
      String dateTime = data['data']['time']['iso'];
      print(dateTime);
      DateTime now = DateTime.parse(dateTime);
      now = now.add(Duration(hours: int.parse(timeZone)));

      // set the properties
      setState(() {
        time = DateFormat.jm().format(now);
        airQualityIndex = airQuality;
        dominentPoll = dominentPol;
      });
    } catch (e) {
      throw e;
    }
    return position;
  }

  // @override
  // void initState() {
  //   super.initState();
  //   //determinePosition();
  //   print('location');
  // }

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty
        ? data
        : ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(
        title: Text('Air Quality App'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton.icon(
            onPressed: () {
              determinePosition();
            },
            icon: Icon(Icons.edit_location),
            label: Text('Current Location'),
          ),
          currentAddress != null
              ? Text(
                  currentAddress!,
                  style: TextStyle(
                    fontSize: 28.0,
                    letterSpacing: 2.0,
                  ),
                )
              : Container(),
          airQualityIndex != null
              ? Text(
                  'Air Quality: ' + airQualityIndex.toString(),
                  style: TextStyle(
                    fontSize: 28.0,
                    letterSpacing: 2.0,
                  ),
                )
              : Container(),
          dominentPoll != null
              ? Text(
                  'Dominent Pol: ' + dominentPoll.toString(),
                  style: TextStyle(
                    fontSize: 28.0,
                    letterSpacing: 2.0,
                  ),
                )
              : Container(),
          time != null
              ? Text(
                  'Time: ' + time!.toString(),
                  style: TextStyle(
                    fontSize: 28.0,
                    letterSpacing: 2.0,
                  ),
                )
              : Container(),
          TextButton.icon(
            onPressed: () async {
              dynamic result =
                  await Navigator.pushNamed(context, Locations.routeName);
              if (mounted) {
                setState(() {
                  data = {
                    'location': result['location'],
                    'time': result['time'],
                    'airQualityIndex': result['airQualityIndex'],
                    'dominentPoll': result['dominentPoll'],
                    'flag': result['flag'],
                  };
                });
              }
            },
            label: Text('Edit Location'),
            icon: Icon(Icons.edit_location),
          ),
          SizedBox(
            height: 15.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/${data['flag']}'),
              ),
              SizedBox(
                width: 20.0,
              ),
              Text(
                data['location'],
                style: TextStyle(
                    fontSize: 28.0,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.bold
                    //color: data['isDayTime'] ? Colors.black : Colors.white,
                    ),
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Air Quality Index: ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              ),
              Text(
                data['airQualityIndex'].toString(),
                style: TextStyle(fontSize: 28.0),
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Dominent Pol: ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              ),
              Text(
                data['dominentPoll'],
                style: TextStyle(fontSize: 28.0),
              )
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Time: ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              ),
              Text(
                data['time'],
                style: TextStyle(
                  fontSize: 28.0,
                  //color: data['isDayTime'] ? Colors.black : Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
