import 'package:flutter/material.dart';
import 'package:note_reminder/screen_splash.dart';

import 'listview_catatan.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note Reminder Demo',
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