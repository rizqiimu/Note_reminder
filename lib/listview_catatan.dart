import 'package:flutter/material.dart';
import 'catatan.dart';
import 'db_helper.dart';
import 'screen_catatan.dart';

class ListViewCatatan extends StatefulWidget {
  @override
  _ListViewCatatanState createState() => _ListViewCatatanState();
}

class _ListViewCatatanState extends State<ListViewCatatan> {
  List<Catatan> items = List();
  DbHelper db = DbHelper();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("List")),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () => _createCatatanBaru(context),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Container(
              color: Colors.blueGrey[100],
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage("img/bg-1.png"))),
                accountName: Text("Time Reminder",
                    style:
                        TextStyle(fontSize: 30, color: Colors.blueAccent[100])),
                accountEmail: null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ListTile(
                leading: Icon(Icons.account_circle),
                title: Text("About Aplikasi"),
              ),
            )
          ],
        ),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: items.length,
          padding: const EdgeInsets.all(15),
          itemBuilder: (context, position) {
            return Column(
              children: <Widget>[
                Card(
                  child: ListTile(
                    title: Text("${items[position].judul}"),
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
      ),
    );
  }

  void _deleteNote(BuildContext context, Catatan catatan, int position) {
    AlertDialog alert = AlertDialog(
      title: Text("Hapus catatan?\n"),
      content:
          Text("Apakah anda yakin menghapus catatan ${items[position].judul} "),
      actions: <Widget>[
        RaisedButton(
          child: Text(
            "tidak",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        RaisedButton(
          child: Text("ya", style: TextStyle(color: Colors.white)),
          onPressed: () {
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
            builder: (context) => ScreenCatatan(Catatan('', '', '', ''))));

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
}
