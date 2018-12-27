import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:ticket_collection/DB/Ticket.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  final String ticketTable = 'ticketTable';
  final String columnId = 'id';
  final String columnDay = 'day';
  final String columnMonth = 'month';
  final String columnYear = 'year';
  final String columnOrigin = 'origin';
  final String columnDestination = 'destination';
  final String columnAircraft = 'aircraft';
  final String columnAirline = 'airline';

  static Database _db;

  DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }

  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'ticket.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $ticketTable($columnId INTEGER PRIMARY KEY, $columnDay TEXT, $columnMonth TEXT, $columnYear TEXT, $columnOrigin TEXT, $columnDestination TEXT, $columnAircraft TEXT, $columnAirline TEXT)');
  }

  Future<int> saveTicket(Ticket ticket) async {
    var dbClient = await db;
    var result = await dbClient.insert(ticketTable, ticket.toMap());
    return result;
  }

  Future<List> getAllTickets() async {
    var dbClient = await db;
    var result = await dbClient.query(ticketTable, columns: [
      columnId,
      columnDay,
      columnMonth,
      columnYear,
      columnOrigin,
      columnDestination,
      columnAircraft,
      columnAirline
    ]);
    return result.toList();
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery('SELECT COUNT(*) FROM $ticketTable'));
  }

  Future<Ticket> getTicket(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query(ticketTable,
        columns: [
          columnId,
          columnDay,
          columnMonth,
          columnYear,
          columnOrigin,
          columnDestination,
          columnAircraft,
          columnAirline
        ],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (result.length > 0) {
      return new Ticket.fromMap(result.first);
    }
    return null;
  }

  Future<int> deleteTicket(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(ticketTable, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> updateTicket(Ticket ticket) async {
    var dbClient = await db;
    return await dbClient.update(ticketTable, ticket.toMap(),
        where: "$columnId = ?", whereArgs: [ticket.id]);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}