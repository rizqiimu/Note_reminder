import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Color.fromARGB(255, 68, 44, 46),
              displayColor: Colors.white,
            ),
        iconTheme: Theme.of(context).iconTheme,
        title: Text(
          "About",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 130,
              width: 130,
              child: CircleAvatar(
                backgroundImage: AssetImage(
                  "assets/images/logo.jpg",
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(16),
              child: Text(
                  'Catatan pengingat merupakan aplikasi pengingat catatan yang user friendly. \nAplikasi ini dibuat oleh tim flutter yang beranggotakan 5 orang, yaitu Aditya, Aditya A, Aziz, Rizqi, dan Rizal.',
                  style: TextStyle(
                    fontSize: 19,
                    color: Color.fromARGB(255, 68, 44, 46),
                  ),
                  textAlign: TextAlign.justify),
            ),
          ],
        ),
      ),
    );
  }
}
