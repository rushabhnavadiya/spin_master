

import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:spin_master/Model/LinkModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper{
  static final String dbName = 'CoinData.db';
  static final int dbVersion = 1;

//////////////////// Coin /////////////////////////
  final String coinTable = 'coin_table';
  final String colId = 'id';
  final String colDate = 'date';
  final String colCoinList = 'link';
  // final String colTitle = 'title';
  // final String colLink = 'link';
///////////////////////////////////////////////////////


  // Make this a singleton class.
  DatabaseHelper.privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper.privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async{
    if(_database != null) return _database;
    _database = await initDatabase();
    return _database;
  }

  initDatabase() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path,dbName);

    return await openDatabase(path,version: dbVersion,onCreate: _onCreate,onUpgrade: _onUpgrade);
  }

  Future _onCreate(Database db,int version) async{
    await db.execute('''
          CREATE TABLE $coinTable(
          $colId INTEGER PRIMARY KEY AUTOINCREMENT,
          $colDate TEXT NOT NULL,
          $colCoinList TEXT NOT NULL
          )
    ''');
  }
  void _onUpgrade(Database database, int oldVersion, int newVersion) {
    if (newVersion > oldVersion) {
      // Upgrade your DB schema
    }
  }

  Future insertLinkModel(LinkModel linkModel) async{
    Database db = await database;
    var result = await db.insert(coinTable, linkModel.toJson1());
    return result;
  }

  Future<List<LinkModel>> getCoins() async{
    Database db = await database;
    var res = await db.query(coinTable);
    List<LinkModel> list = res.isNotEmpty?res.map((e) => LinkModel.fromJson1(e)).toList():[];
    return list;
  }

  Future<bool> clean() async {
    try{
      Database db = await database;
      await db.transaction((txn) async {
        var batch = txn.batch();
        batch.delete(coinTable);
        await batch.commit();
      });
      return true;
    } catch(error){
      throw Exception('DbBase.cleanDatabase: ' + error.toString());
    }
  }
}