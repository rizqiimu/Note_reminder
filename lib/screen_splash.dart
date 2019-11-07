import 'package:flutter/material.dart';
import 'dart:async';

import 'listview_catatan.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ListViewCatatan()));
    });
    return Scaffold(
      body: Center(
        child: Container(
          // color: Colors.blueGrey[100],
          child: Image.asset("logo-1.jpeg")),
      ),
    );
  }
}
