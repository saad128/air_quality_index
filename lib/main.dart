import 'package:air_quality_index/screens/home.dart';
import 'package:air_quality_index/screens/loading.dart';
import 'package:air_quality_index/screens/locations.dart';
import 'package:flutter/material.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: Loading.routeName,
        //home: Home(),
        routes: {
          Home.routeName: (ctx) => Home(),
          Locations.routeName: (ctx) => Locations(),
          Loading.routeName: (ctx) => Loading(),
        },
      ),
    );
