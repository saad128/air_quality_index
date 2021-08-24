import 'dart:convert';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class AirQualityIndex {
  String? location;
  String? url;
  String? time;
  String? flag;
  int? airQualityIndex;
  String? dominentPoll;

  AirQualityIndex(
      {this.location, this.url, this.flag});

  Future<void> getAirQuality() async {
    try {
      // make the request
      String value = 'ad116a0c87bdf7ab17cac30c0aeec3817b9782ca';
      Response response = await get(
          Uri.parse('https://api.waqi.info/feed/$url/?token=$value'));
      Map data = json.decode(response.body);
      // print the data

      // get the properties from data
      int airQuality = data['data']['aqi'];
      String dominentPol = data['data']['dominentpol'];
      String timeZone = data['data']['time']['tz'].substring(1, 3);
      String dateTime = data['data']['time']['iso'];

      // create dateTime object
      DateTime now = DateTime.parse(dateTime);
      now = now.add(Duration(hours: int.parse(timeZone)));

      // set the properties
      time = DateFormat.jm().format(now);
      airQualityIndex = airQuality;
      dominentPoll = dominentPol;
    } catch (e) {
      print('caught error: $e');
      time = 'Could not get Time Data';
      dominentPoll = 'Could not get Dominent Pol';
      //airQualityIndex = 'Could not get Air Quality Index' as int?;
    }
  }
}
