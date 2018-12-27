import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ticket_collection/DB/DatabaseHelper.dart';
import 'package:ticket_collection/DB/Ticket.dart';
import 'package:ticket_collection/UI/TicketScreen.dart';

class MyListView extends StatefulWidget {
  @override
  _ListViewState createState() => new _ListViewState();
}

class _ListViewState extends State<MyListView> {
  List<Ticket> items = new List();
  DatabaseHelper db = new DatabaseHelper();

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

  Future<Null> _delete(
      BuildContext context, Ticket ticket, int position) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Do you want to delete?'),
          actions: <Widget>[
            new FlatButton(
                child: new Text('YES'),
                onPressed: () {
                  _deleteTicket(context, ticket, position);
                  Navigator.of(context).pop();
                }),
            new FlatButton(
              child: new Text('NO'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    db.getAllTickets().then((tickets) {
      setState(() {
        tickets.forEach((ticket) {
          items.add(Ticket.fromMap(ticket));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Kadri's Ticket Collection",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Kadri's total flights:  ${items.length.toString()}"),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: ListView.builder(
              itemCount: items.length,
              padding: const EdgeInsets.all(15.0),
              itemBuilder: (context, position) {
                return Card(
                  color: getRandomColor(),
                  child: Column(
                    children: <Widget>[
                      Divider(height: 5.0),
                      ListTile(
                        title: Text(
                          'From ${items[position].origin} to ${items[position].destination}',
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Operated by ${items[position].airline}',
                              style: new TextStyle(
                                fontSize: 18.0,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Text(
                              'Aircraft: ${items[position].aircraft}',
                              style: new TextStyle(
                                fontSize: 18.0,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                        leading: Container(
                          width: 120.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
//                          Padding(padding: EdgeInsets.all(5.0)),
                              Text(
                                '${items[position].day}/${items[position].month}/${items[position].year}',
                                style: TextStyle(
                                  fontSize: 22.0,
                                  color: Colors.indigo,
                                ),
                              ),

                              IconButton(
                                  icon: const Icon(Icons.cancel),
                                  onPressed: () => _delete(
                                      context, items[position], position)),
                            ],
                          ),
                        ),
                        onTap: () =>
                            _navigateToTicket(context, items[position]),
                      ),
                    ],
                  ),
                );
              }),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _createNewTicket(context),
        ),
      ),
    );
  }

  void _deleteTicket(BuildContext context, Ticket ticket, int position) async {
    db.deleteTicket(ticket.id).then((tickets) {
      setState(() {
        items.removeAt(position);
      });
    });
  }

  void _navigateToTicket(BuildContext context, Ticket ticket) async {
    String result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TicketScreen(ticket)),
    );

    if (result == 'update') {
      db.getAllTickets().then((tickets) {
        setState(() {
          items.clear();
          tickets.forEach((ticket) {
            items.add(Ticket.fromMap(ticket));
          });
        });
      });
    }
  }

  void _createNewTicket(BuildContext context) async {
    String result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              TicketScreen(Ticket('', '', '', '', '', '', ''))),
    );

    if (result == 'save') {
      db.getAllTickets().then((tickets) {
        setState(() {
          items.clear();
          tickets.forEach((ticket) {
            items.add(Ticket.fromMap(ticket));
          });
        });
      });
    }
  }
}
