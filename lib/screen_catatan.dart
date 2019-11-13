import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:device_id/device_id.dart';
import 'package:flutter/material.dart';
import 'package:note_reminder/catatan.dart';
import 'package:note_reminder/db_helper.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';

class ScreenCatatan extends StatefulWidget {
  final Catatan catatan;
  ScreenCatatan(this.catatan);
  @override
  _ScreenCatatanState createState() => _ScreenCatatanState();
}

class _ScreenCatatanState extends State<ScreenCatatan> {
  DbHelper db = DbHelper();
  TextEditingController _controllerJudul;
  TextEditingController _controllerCatatan;
  TextEditingController _controllerDate;
  TextEditingController _controllerTime;
  String _deviceId = "";
  int selection = 1100 + (Random(1).nextInt(2000 - 1000));
  @override
  void initState() {
    super.initState();

    _controllerJudul = TextEditingController(text: widget.catatan.judul);
    _controllerCatatan = TextEditingController(text: widget.catatan.catatan);
    _controllerDate = TextEditingController(text: widget.catatan.date);
    _controllerTime = TextEditingController(text: widget.catatan.time);
    getDeviceId();
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

  Future<void> getDeviceId() async {
    String deviceId;
    deviceId = await DeviceId.getID;

    if (!mounted) return;

    setState(() {
      _deviceId = deviceId;
    });
    print(deviceId);
  }

  void addData() {
    var url = "http://adityo.xyz/jatis/jatis_tambahdata.php";

    http.post(url, body: {
      "id": 100000,
      "judul": _controllerJudul.text,
      "deskripsi": _controllerCatatan.text,
      "tanggal": "${_controllerDate.text} ${_controllerTime.text}",
      "device_id": _deviceId
    });

    print(http.Response);
    print("${_controllerDate.text} ${_controllerTime.text}");
    print(selection);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        textTheme: Theme.of(context).textTheme,
        iconTheme: Theme.of(context).iconTheme,
        title: Text("Catatan"),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(12),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _controllerJudul,
                  decoration: InputDecoration(
                    labelText: 'Judul',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                TextField(
                  maxLines: 9,
                  controller: _controllerCatatan,
                  decoration: InputDecoration(
                      labelText: 'catatan',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7))),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.date_range),
                          Text(
                              (_controllerDate.text.length == 0)
                                  ? 'Not set'
                                  : '${_controllerDate.text}',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 68, 44, 46),
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      onPressed: () {
                        DatePicker.showDatePicker(context,
                            theme: DatePickerTheme(containerHeight: 210),
                            showTitleActions: true,
                            minTime: DateTime.now(),
                            maxTime: DateTime(2022, 12, 31), onConfirm: (date) {
                          print('confirm $date');

                          setState(() {
                            _controllerDate.text =
                                "${date.year}-${date.month}-${date.day}";
                          });
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                      },
                    ),
                    FlatButton(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.access_time),
                          Text(
                            (_controllerTime.text.length == 0)
                                ? 'Not set'
                                : '${_controllerTime.text}',
                            style: TextStyle(
                                color: Color.fromARGB(255, 68, 44, 46),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      onPressed: () {
                        DatePicker.showTimePicker(context,
                            theme: DatePickerTheme(containerHeight: 210),
                            showTitleActions: true, onConfirm: (time) {
                          print('confirm $time');

                          setState(() {
                            _controllerTime.text =
                                '${time.hour}:${time.minute}:00';
                          });
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                      },
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    RaisedButton(
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      child: (widget.catatan.id != null)
                          ? Text("update")
                          : Text(
                              "Add",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 68, 44, 46),
                                  fontWeight: FontWeight.bold),
                            ),
                      onPressed: () async {
                        print(widget.catatan.id);
                        if (widget.catatan.id != null) {
                          db
                              .updateCatatan(Catatan.fromMap({
                            'id': widget.catatan.id,
                            'judul': _controllerJudul.text,
                            'catatan': _controllerCatatan.text,
                            'date': _controllerDate.text,
                            'time': _controllerTime.text
                          }))
                              .then((_) {
                            Navigator.pop(context, 'update');
                          });
                        } else {
                          // var connectivityResult =
                          //     await (Connectivity().checkConnectivity());
                          // if (connectivityResult == ConnectivityResult.mobile) {
                          //   print("connected");
                          // } else if (connectivityResult ==
                          //     ConnectivityResult.wifi) {
                          //   print("connected");
                          // } else {
                          //   print("not connected");
                          // }

                          try {
                            final result =
                                await InternetAddress.lookup('google.com');
                            if (result.isNotEmpty &&
                                result[0].rawAddress.isNotEmpty) {
                              addData();
                              db
                                  .saveCatatan(Catatan(
                                    selection,
                                      _controllerJudul.text,
                                      _controllerCatatan.text,
                                      _controllerDate.text,
                                      _controllerTime.text,
                                      "$_deviceId"))
                                  .then((_) {
                                Navigator.pop(context, 'save');
                              });
                              print("tersimpan di internet dan local");
                            }
                          } on SocketException catch (_) {
                            db
                                .saveCatatan(Catatan(
                                  selection,
                                    _controllerJudul.text,
                                    _controllerCatatan.text,
                                    _controllerDate.text,
                                    _controllerTime.text,
                                    _deviceId))
                                .then((_) {
                              Navigator.pop(context, 'save');
                            });
                            print("tersimpan di local");
                          }
                        }
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
