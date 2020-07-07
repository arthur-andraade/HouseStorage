//Class modelo para tabala no DB do "Item"

final String itemTabelaNome = "item";
final String itemColunaId = "item_id";
final String itemColunaNome = "item_nome";
final String itemColunaQuantidade = "item_quantidade";
final String itemColunaStorage = "item_storage";

class Item {
  
  int id;
  String nome;
  int quantidade;
  String storage;

  Item();
  Item.fromMap(Map map) {
    id = map[itemColunaId];
    nome = map[itemColunaNome];
    quantidade = map[itemColunaQuantidade];
    storage = map[itemColunaStorage];
  }

  Map constrouiMapItem() {
    Map<String, dynamic> item = {
      itemColunaNome: this.nome,
      itemColunaQuantidade: this.quantidade,
      itemColunaStorage: this.storage
    };

    if (this.id != null) {
      item[itemColunaId] = this.id;
    }

    return item;
  }
}
