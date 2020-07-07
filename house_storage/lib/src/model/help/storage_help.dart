import 'dart:async';
import 'package:house_storage/src/model/item.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Storagehelp {
  static final Storagehelp _instance = Storagehelp.internal();

  factory Storagehelp() => _instance;

  Storagehelp.internal();

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
      await db.execute("CREATE TABLE $itemTabelaNome("
          "   $itemColunaId INTEGER PRIMARY KEY,"
          "   $itemColunaNome TEXT ,"
          "   $itemColunaQuantidade INTEGER ,"
          "   $itemColunaStorage TEXT"
          ")");
    });
  }

  //Buscando TODOS os items
  Future<List> getTodosItens() async {
    Database dbStorage = await db;
    List list;
    List<Item> listaDeItem = List();

    list = await dbStorage.rawQuery(
        "SELECT * FROM $itemTabelaNome WHERE $itemColunaStorage = ?",
        [rotulo]);
    for (Map m in list) {
      listaDeItem.add(Item.fromMap(m));
    }

    return listaDeItem;
  }

  Future<int> salvandoNovoItem(Item item) async {
    print(item.constrouiMapItem());
    Database dbStorage = await db;
    return dbStorage.insert(itemTabelaNome, item.constrouiMapItem());
  }

  Future<int> deletandoItem(Item item) async {
    Database dbStorage = await db;
    return await dbStorage.delete(itemTabelaNome,
        where: '$itemColunaId = ?', whereArgs: [item.id]);
  }

  Future<int> alterandoQuantidadeDeItem(Item item) async {
    Database dbStorage = await db;
    return dbStorage.update(
        itemTabelaNome, {itemColunaQuantidade: item.quantidade},
        where: '$itemColunaId = ?', whereArgs: [item.id]);
  }

  Future<int> alterandoNomeDoItem(Item item) async{
    Database dbStorage = await db;
    return dbStorage.update(
        itemTabelaNome, {itemColunaNome: item.nome},
        where: '$itemColunaId = ?', whereArgs: [item.id]);
  }  
}
