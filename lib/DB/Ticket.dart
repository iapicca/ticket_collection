class Ticket {
  int _id;
  String _day;
  String _month;
  String _year;
  String _origin;
  String _destination;
  String _aircraft;
  String _airline;



  Ticket(this._day, this._month, this._year, this._origin, this._destination, this._aircraft, this._airline);

  Ticket.map(dynamic obj) {
    this._id = obj['id'];
    this._day = obj['day'];
    this._month = obj['month'];
    this._year = obj['year'];
    this._origin = obj['origin'];
    this._destination = obj['destination'];
    this._aircraft = obj['aircraft'];
    this._airline = obj['airline'];
  }

  int get id => _id;
  String get day => _day;
  String get month => _month;
  String get year => _year;
  String get origin => _origin;
  String get destination =>_destination;
  String get aircraft =>_aircraft;
  String get airline => _airline;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['day'] = _day;
    map['month'] = _month;
    map['year'] = _year;
    map['origin'] = _origin;
    map['destination'] = _destination;
    map['aircraft'] = _aircraft;
    map['airline'] = _airline;

    return map;
  }

  Ticket.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._day = map['day'];
    this._month = map['month'];
    this._year = map['year'];
    this._origin =  map['origin'];
    this._destination = map['destination'];
    this._aircraft = map['aircraft'];
    this._airline = map['airline'];
  }
}