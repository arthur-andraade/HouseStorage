import 'dart:async';
import 'package:house_storage/src/model/item.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Storage_help {
  static final Storage_help _instance = Storage_help.internal();

  factory Storage_help() => _instance;

  Storage_help.internal();

  Database _db;
  String rotulo;
  Future<Database> get db async {
    if (_db == null) {
      _db = await initDB();
      return _db;
    } else {
      return _db;
    }
  }

  //Nome do STORAGE
  void setRotulo(String rotulo) {
    this.rotulo = rotulo;
  }

  //CRIANDO DATABASE
  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "ItensStorage.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newVersion) async {
      //Criando DB com tabela "storage"
      await db.execute("CREATE TABLE $item_tabelaNome("
          "   $item_colunaId INTEGER PRIMARY KEY,"
          "   $item_colunaNome TEXT ,"
          "   $item_colunaQuantidade INTEGER ,"
          "   $item_colunaStorage TEXT"
          ")");
    });
  }

  //Buscando TODOS os items
  Future<List> getTodosItens() async {
    Database dbStorage = await db;
    List list;
    List<Item> listaDeItem = List();

    list = await dbStorage.rawQuery(
        "SELECT * FROM $item_tabelaNome WHERE $item_colunaStorage = ?",
        [rotulo]);
    for (Map m in list) {
      listaDeItem.add(Item.fromMap(m));
    }

    return listaDeItem;
  }

  Future<int> salvandoNovoItem(Item item) async {
    print(item.constrouiMapItem());
    Database dbStorage = await db;
    return dbStorage.insert(item_tabelaNome, item.constrouiMapItem());
  }

  Future<int> deletandoItem(Item item) async {
    Database dbStorage = await db;
    return await dbStorage.delete(item_tabelaNome,
        where: '$item_colunaId = ?', whereArgs: [item.id]);
  }

  Future<int> alterandoQuantidadeDeItem(Item item) async {
    Database dbStorage = await db;
    return dbStorage.update(
        item_tabelaNome, {item_colunaQuantidade: item.quantidade},
        where: '$item_colunaId = ?', whereArgs: [item.id]);
  }

  Future<int> alterandoNomeDoItem(Item item) async{
    Database dbStorage = await db;
    return dbStorage.update(
        item_tabelaNome, {item_colunaNome: item.nome},
        where: '$item_colunaId = ?', whereArgs: [item.id]);
  }  
}
