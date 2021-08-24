import 'package:air_quality_index/screens/locations.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  static const routeName = '/home';

  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty
        ? data
        : ModalRoute
        .of(context)!
        .settings
        .arguments as Map;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
      ),
    );
  }
}
