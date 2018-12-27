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
      title: 'Ticket List',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Ticket List'),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: ListView.builder(
              itemCount: items.length,
              padding: const EdgeInsets.all(15.0),
              itemBuilder: (context, position) {
                return Column(
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
                      subtitle:
                        Text(
                          'Operated by ${items[position].airline} with  ${items[position].aircraft} ',
                          style: new TextStyle(
                            fontSize: 18.0,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      leading: Column(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.all(10.0)),
                          Text(
                              '${items[position].day}/${items[position].month}/${items[position].year}',
                              style: TextStyle(
                                fontSize: 22.0,
                                color: Colors.indigo,
                              ),
                            ),

                          IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () => _deleteTicket(context, items[position], position)
                          ),
                        ],
                      ),
                      onTap: () => _navigateToTicket(context, items[position]),
                    ),
                  ],
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
      MaterialPageRoute(builder: (context) => TicketScreen(Ticket('', '', '', '', '', '', ''))),
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