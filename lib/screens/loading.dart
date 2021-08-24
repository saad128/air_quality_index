import 'package:air_quality_index/screens/home.dart';
import 'package:air_quality_index/services/air_quality_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  static const routeName = '/loading';

  const Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void setupAirQuality() async {
    AirQualityIndex instance = AirQualityIndex(
        location: 'Karachi',
        url: 'karachi',
        flag: 'pakistan'
            '.png');
    await instance.getAirQuality();
    Navigator.pushReplacementNamed(context, Home.routeName, arguments: {
      'location': instance.location,
      'time': instance.time,
      'airQualityIndex': instance.airQualityIndex,
      'dominentPoll': instance.dominentPoll,
      'flag': instance.flag,
    });
  }

  @override
  void initState() {
    super.initState();
    setupAirQuality();
    print('hey there');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(50.0),
        child: Center(
          child: SpinKitFadingCube(
            color: Colors.white,
            size: 50.0,
          ),
        ),
      ),
    );
  }
}
