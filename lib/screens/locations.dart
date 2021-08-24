import 'package:air_quality_index/services/air_quality_index.dart';
import 'package:flutter/material.dart';

class Locations extends StatefulWidget {
  static const routeName = '/locations';

  const Locations({Key? key}) : super(key: key);

  @override
  _LocationsState createState() => _LocationsState();
}

class _LocationsState extends State<Locations> {
  List<AirQualityIndex> locations = [
    AirQualityIndex(url: 'lahore', location: 'Lahore', flag: 'pakistan.png'),
    AirQualityIndex(url: 'peshawar', location: 'Peshawar',flag: 'pakistan.png' ),
    AirQualityIndex(url: 'shanghai', location: 'Shanghai',flag: 'pakistan.png'),
    AirQualityIndex(url: 'bangalore', location: 'Bangalore',flag: 'india.png'),
    AirQualityIndex(url: 'mumbai', location: 'Mumbai',flag: 'india.png'),
    AirQualityIndex(url: 'islamabad', location: 'Islamabad',flag: 'pakistan.png'),
    AirQualityIndex(url: 'bangkok', location: 'Bangkok',flag: 'thailand.jpg'),
    AirQualityIndex(url: 'seoul', location: 'Seoul',flag: 'south_korea.png'),
    AirQualityIndex(url: 'beijing', location: 'Beijing',flag: 'china.png'),
    AirQualityIndex(url: 'paris', location: 'Paris',flag: 'france.png'),
    AirQualityIndex(url: 'berlin', location: 'Berlin',flag: 'germany.png'),
  ];

  void updateAirQuality(index) async {
    AirQualityIndex instance = locations[index];
    await instance.getAirQuality();

    Navigator.pop(context, {
      'location': instance.location,
      'time': instance.time,
      'airQualityIndex': instance.airQualityIndex,
      'dominentPoll': instance.dominentPoll,
      'flag' : instance.flag,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Choose Location'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
          itemCount: locations.length,
          itemBuilder: (context, index) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
              child: Card(
                child: ListTile(
                  onTap: () {
                    updateAirQuality(index);
                  },
                  title: Text(locations[index].location!),
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('assets/${locations[index].flag}'),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
