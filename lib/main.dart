import 'package:flutter/material.dart';
import 'package:note_reminder/screen_splash.dart';

import 'listview_catatan.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Note Reminder Demo',
      theme: ThemeData(
          primaryColor: Colors.green,
          accentColor: Colors.green,
          fontFamily: 'Raleway',
          iconTheme: new IconThemeData(
            color: Colors.black,
          ),
          textTheme: TextTheme(
            title: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 68, 44, 46)),
          )),
      home: Splash(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListViewCatatan();
  }
}
