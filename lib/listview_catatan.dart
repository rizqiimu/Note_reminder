import 'dart:async';
import 'dart:convert';
import 'package:device_id/device_id.dart';
import 'package:flutter/material.dart';
import 'package:note_reminder/screen_about.dart';
import 'catatan.dart';
import 'db_helper.dart';
import 'screen_catatan.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;

class ListViewCatatan extends StatefulWidget {
  @override
  _ListViewCatatanState createState() => _ListViewCatatanState();
}

class _ListViewCatatanState extends State<ListViewCatatan> {
  List<Catatan> items = List();
  DbHelper db = DbHelper();
  shapeCustom1() =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(6));

  // void deleteData() {
  //   var url = "http://adityo.xyz/jatis/jatis_delete.php";
  //   http.post(url, body: {'id': widget.list[widget.index]['id']});
  // }
  String _deviceId = "";

  Future<void> getDeviceId() async {
    String deviceId;
    deviceId = await DeviceId.getID;

    if (!mounted) return;

    setState(() {
      _deviceId = deviceId;
    });
    print(deviceId);
  }

  

  @override
  void initState() {
    super.initState();
    db.getAllCatatan().then((catatans) {
      setState(() {
        catatans.forEach((catatan) {
          items.add(Catatan.fromMap(catatan));
        });
      });
    });
  }

  Future<void> checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile &&
        connectivityResult == ConnectivityResult.wifi) {
      print("connected");
    } else {
      print("not connected");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        textTheme: Theme.of(context).textTheme,
        title: Text("Catatan"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () => _createCatatanBaru(context),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Container(
              color: Colors.green,
              child: UserAccountsDrawerHeader(
                accountName: Text("Catatan Pengingat",
                    style: TextStyle(
                      fontSize: 25,
                      color: Color.fromARGB(255, 68, 44, 46),
                    )),
                accountEmail: null,
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: ListTile(
                leading: Icon(Icons.info),
                title: Text("Tentang Aplikasi"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => About()));
                },
              ),
            )
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: items.length,
        padding: const EdgeInsets.all(15),
        itemBuilder: (context, position) {
          return Column(
            children: <Widget>[
              Card(
                shape: shapeCustom1(),
                child: ListTile(
                  contentPadding: EdgeInsets.all(8),
                  title: Text(
                    "${items[position].judul}",
                    style: TextStyle(fontSize: 18),
                  ),
                  subtitle: Text(
                    "${items[position].catatan}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => _navigateToCatatan(context, items[position]),
                  onLongPress: () =>
                      _deleteNote(context, items[position], position),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _deleteNote(BuildContext context, Catatan catatan, int position) {
    AlertDialog alert = AlertDialog(
      shape: shapeCustom1(),
      title: Text("Hapus catatan?\n",
          style: TextStyle(fontWeight: FontWeight.bold)),
      content:
          Text("Apakah anda yakin menghapus catatan ${items[position].judul} "),
      actions: <Widget>[
        RaisedButton(
          color: Colors.green,
          shape: shapeCustom1(),
          child: Text("tidak",
              style: TextStyle(
                  color: Color.fromARGB(255, 68, 44, 46),
                  fontWeight: FontWeight.bold)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        RaisedButton(
          color: Colors.green,
          shape: shapeCustom1(),
          child: Text("ya",
              style: TextStyle(
                  color: Color.fromARGB(255, 68, 44, 46),
                  fontWeight: FontWeight.bold)),
          onPressed: () {
            // var url = "http://adityo.xyz/jatis/jatis_delete.php";
            // http.post(url, body: {'id': list['index']['id']});

            db.deleteCatatan(catatan.id).then((catatans) {
              setState(() {
                items.removeAt(position);
              });
            });
            Navigator.pop(context);
          },
        )
      ],
    );
    showDialog(context: context, builder: (context) => alert);
  }

  void _navigateToCatatan(BuildContext context, Catatan catatan) async {
    String result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ScreenCatatan(catatan)));

    if (result == 'update') {
      db.getAllCatatan().then((catatans) {
        setState(() {
          items.clear();
          catatans.forEach((catatan) {
            items.add(Catatan.fromMap(catatan));
          });
        });
      });
    }
  }

  void _createCatatanBaru(BuildContext context) async {
    String result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ScreenCatatan(Catatan(null,'', '', '', '', ''))));

    if (result == 'save') {
      db.getAllCatatan().then((catatans) {
        setState(() {
          items.clear();
          catatans.forEach((catatan) {
            items.add(Catatan.fromMap(catatan));
          });
        });
      });
    }
  }

  // void deleteData() {
  //   var url = "http://adityo.xyz/jatis/jatis_delete.php";
  //   http.post(url, body: {'id': widget.list[widget.index]['id']});
  // }
}
