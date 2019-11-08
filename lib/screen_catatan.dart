import 'package:flutter/material.dart';
import 'package:note_reminder/catatan.dart';
import 'package:note_reminder/db_helper.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

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
  String _date = "Not set";
  String _time = "Not set";

  @override
  void initState() {
    super.initState();

    _controllerJudul = TextEditingController(text: widget.catatan.judul);
    _controllerCatatan = TextEditingController(text: widget.catatan.catatan);
    _controllerDate = TextEditingController(text: widget.catatan.date);
    _controllerTime = TextEditingController(text: widget.catatan.time);
    _date = _controllerDate.text;
    _time = _controllerTime.text;
    // _date = _controllerDate.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(12),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _controllerJudul,
                    decoration: InputDecoration(
                        labelText: 'judul',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7))),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                  ),
                  TextField(
                    maxLines: 8,
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
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        onPressed: () {
                          DatePicker.showDatePicker(context,
                              theme: DatePickerTheme(containerHeight: 210),
                              showTitleActions: true,
                              minTime: DateTime.now(),
                              maxTime: DateTime(2022, 12, 31),
                              onConfirm: (date) {
                            print('confirm $date');

                            setState(() {
                              _controllerDate.text =
                                  "${date.year} - ${date.month} - ${date.day}";
                              print("tanggal: ${_controllerDate.text}");
                              _date = _controllerDate.text;
                            });
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.en);
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.date_range),
                            Text((_date.length == 0) ? 'Not set' : '$_date'),
                          ],
                        ),
                      ),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        onPressed: () {
                          DatePicker.showTimePicker(context,
                              theme: DatePickerTheme(containerHeight: 210),
                              showTitleActions: true, onConfirm: (time) {
                            print('confirm $time');

                            setState(() {
                              _time =
                                  '${time.hour} : ${time.minute} : ${time.second}';
                              _controllerTime.text = _time;
                            });
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.en);
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.access_time),
                            Text((_time.length == 0) ? 'Not set' : '$_time'),
                          ],
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      RaisedButton(
                        child: (widget.catatan.id != null)
                            ? Text("update")
                            : Text("Add"),
                        onPressed: () {
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
                            db
                                .saveCatatan(Catatan(
                                    _controllerJudul.text,
                                    _controllerCatatan.text,
                                    _controllerDate.text,
                                    _controllerTime.text))
                                .then((_) {
                              Navigator.pop(context, 'save');
                            });
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
      ),
    );
  }
}
