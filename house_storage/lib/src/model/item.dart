//Class modelo para tabala no DB do "Item"

final String item_tabelaNome = "item";
final String item_colunaId = "item_id";
final String item_colunaNome = "item_nome";
final String item_colunaQuantidade = "item_quantidade";
final String item_colunaStorage = "item_storage";

class Item {
  
  int id;
  String nome;
  int quantidade;
  String storage;

  Item();
  Item.fromMap(Map map) {
    id = map[item_colunaId];
    nome = map[item_colunaNome];
    quantidade = map[item_colunaQuantidade];
    storage = map[item_colunaStorage];
  }

  Map constrouiMapItem() {
    Map<String, dynamic> item = {
      item_colunaNome: this.nome,
      item_colunaQuantidade: this.quantidade,
      item_colunaStorage: this.storage
    };

    if (this.id != null) {
      item[item_colunaId] = this.id;
    }

    return item;
  }
}
