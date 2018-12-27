
import 'package:flutter/material.dart';
import 'package:ticket_collection/DB/DatabaseHelper.dart';
import 'package:ticket_collection/DB/Ticket.dart';
import 'dart:math';


class TicketScreen extends StatefulWidget {
  final Ticket ticket;
  TicketScreen(this.ticket);

  @override
  State<StatefulWidget> createState() => new _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  DatabaseHelper db = new DatabaseHelper();

  TextEditingController _dayController;
  TextEditingController _monthController;
  TextEditingController _yearController;
  TextEditingController _originController;
  TextEditingController _destinationController;
  TextEditingController _aircraftController;
  TextEditingController _airlineController;

  List<Color> colors = [
    Colors.pink[200],
    Colors.limeAccent[700],
    Colors.redAccent[100],
    Colors.amber[200],
    Colors.yellow[300],
    Colors.lightGreenAccent[100],
    Colors.greenAccent[100],
    Colors.tealAccent[100],
    Colors.cyan[100],
    Colors.cyanAccent[100],
    Colors.lightBlueAccent[100],
    Colors.blueAccent[100],
    Colors.indigo[100],
    Colors.indigoAccent[100],
    Colors.purple[100],
    Colors.purpleAccent[100],
    Colors.deepPurple[100],
    Colors.deepPurpleAccent[100],
  ];

  int index = 0;
  Random random = new Random();

  getRandomColor() {
    Color color;
    index = random.nextInt(18);
    color = colors[index];
    return color;
  }

  @override
  void initState() {
    super.initState();
    _dayController = new TextEditingController(text: widget.ticket.day);
    _monthController = new TextEditingController(text: widget.ticket.month);
    _yearController = new TextEditingController(text: widget.ticket.year);
    _originController = new TextEditingController(text: widget.ticket.origin);
    _destinationController =
        new TextEditingController(text: widget.ticket.destination);
    _aircraftController =
        new TextEditingController(text: widget.ticket.aircraft);
    _airlineController = new TextEditingController(text: widget.ticket.airline);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ticket')),
      body: Container(
        width: 500.0,
        height: 300.0,
        margin: EdgeInsets.all(5.0),
        alignment: Alignment.center,
        child: Card(
          color: getRandomColor(),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    width: 80.0,
                    child: TextField(
                      maxLength: 2,
                      keyboardType: TextInputType.number,
                      controller: _dayController,
                      decoration: InputDecoration(labelText: 'Day'),
                    ),
                  ),
                  Text(' / '),
                  Container(
                    width: 80.0,
                    child: TextField(
                      maxLength: 2,
                      keyboardType: TextInputType.number,
                      controller: _monthController,
                      decoration: InputDecoration(labelText: 'Month'),
                    ),
                  ),
                  Text(' / '),
                  Container(
                    width: 160.0,
                    child: TextField(
                      maxLength: 4,
                      keyboardType: TextInputType.number,
                      controller: _yearController,
                      decoration: InputDecoration(labelText: 'Year'),
                    ),
                  ),
                ],
              ),
              //          Padding(padding: new EdgeInsets.all(5.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 160.0,
                    child: TextField(
                      controller: _originController,
                      decoration: InputDecoration(labelText: 'From'),
                    ),
                  ),
                  Container( width: 20.0,),
                  Container(
                    width: 160.0,
                    child: TextField(
                      controller: _destinationController,
                      decoration: InputDecoration(labelText: 'To'),
                    ),
                  ),
                ],
              ),
//            Padding(padding: new EdgeInsets.all(5.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 160.0,
                    child: TextField(
                      controller: _aircraftController,
                      decoration: InputDecoration(labelText: 'Aircraft'),
                    ),
                  ),
                  Container( width: 20.0,),
                  Container(
                    width: 160.0,
                    child: TextField(
                      controller: _airlineController,
                      decoration: InputDecoration(labelText: 'Airline'),
                    ),
                  ),
                ],
              ),
              Padding(padding: new EdgeInsets.all(5.0)),
              RaisedButton(
                child:
                    (widget.ticket.id != null) ? Text('Update') : Text('Add'),
                onPressed: () {
                  if (widget.ticket.id != null) {
                    db
                        .updateTicket(Ticket.fromMap({
                      'id': widget.ticket.id,
                      'day': _dayController.text,
                      'year': _yearController.text,
                      'origin': _originController.text,
                      'destination': _destinationController.text,
                      'aircraft': _aircraftController.text,
                      'airline': _airlineController.text
                    }))
                        .then((_) {
                      Navigator.pop(context, 'update');
                    });
                  } else {
                    db
                        .saveTicket(Ticket(
                            _dayController.text,
                            _monthController.text,
                            _yearController.text,
                            _originController.text,
                            _destinationController.text,
                            _aircraftController.text,
                            _airlineController.text))
                        .then((_) {
                      Navigator.pop(context, 'save');
                    });
                  }
                },
              ),
            ],
          ),

          ),


      ),
    );
  }
}
