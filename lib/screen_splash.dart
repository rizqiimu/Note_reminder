import 'dart:async';
import 'package:flutter/material.dart';
import 'listview_catatan.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return ListViewCatatan();
      }));
    });
    return Scaffold(
      body: Center(
          child: Center(
              child: Container(
                  height: 150, child: Image.asset("img/bg-1.png")))),
    );
  }
}
