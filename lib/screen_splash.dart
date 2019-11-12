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
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: FractionalOffset.topRight,
                end: FractionalOffset.bottomLeft,
                colors: [
              Colors.green,
              Colors.greenAccent,
            ])),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 130,
                width: 130,
                child: CircleAvatar(
                  backgroundImage: AssetImage(
                    "img/logo-1.png",
                  ),
                ),
              ),
              Text("Catatan Pengingat",
                  style: TextStyle(
                      fontSize: 35,
                      color: Color.fromARGB(255, 68, 44, 46),
                      fontWeight: FontWeight.bold))
            ],
          ),
        ),
      ),
    );
  }
}
