class Catatan {
  int _id;
  String _judul;
  String _catatan;
  String _date;
  String _time;

  Catatan(this._judul, this._catatan, this._date, this._time);

  Catatan.map(dynamic obj) {
    this._id = obj['id'];
    this._judul = obj['judul'];
    this._catatan = obj['catatan'];
    this._date = obj['date'];
    this._time = obj['time'];
  }

  int get id => _id;
  String get judul => _judul;
  String get catatan => _catatan;
  String get date => _date;
  String get time => _time;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['judul'] = _judul;
    map['catatan'] = _catatan;
    map['date'] = _date;
    map['time'] = _time;

    return map;
  }

  Catatan.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._judul = map['judul'];
    this._catatan = map['catatan'];
    this._date = map['date'];
    this._time = map['time'];
  }
}
