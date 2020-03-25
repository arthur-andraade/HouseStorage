import 'package:house_storage/src/model/item.dart';
import 'package:flutter/material.dart';
import 'package:house_storage/src/model/help/storage_help.dart';

class StoragePage extends StatefulWidget {
  String _rotulo;

  StoragePage(String rotulo) {
    this._rotulo = rotulo;
  }

  _StorageState createState() => _StorageState(this._rotulo);
}

//----------------> StoreState <----------------------

class _StorageState extends State<StoragePage> {
  //Variáveis
  String _rotulo;
  TextEditingController addNovoItem = new TextEditingController();

  Storage_help controllerDB = Storage_help();
  List<Item> itemStorage = List();
  List<TextEditingController> _controllersQuantidade = List();

  Item _itemRemovido;
  int _indexItemRemovido;

  //Construtor da classe
  _StorageState(String rotulo) {
    this._rotulo = rotulo;
  }

  @override
  void initState() {
    super.initState();

    controllerDB.setRotulo(_rotulo);
    print(controllerDB.rotulo);
    controllerDB.getTodosItens().then((list) {
      //list.forEach((f) {
      //print(f.id);
      //});
      setState(() {
        itemStorage = list;
        addControllerQuantidadeParaItens();
      });
    });
  }

  //Construtor do "LAYOUT"
  @override
  Widget build(BuildContext context) {
    //Layout
    return Scaffold(
      appBar: AppBar(
        title: Text('$_rotulo'),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          //ADICIONANDO NOVO ITEM
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: <Widget>[
                //Insere "NOME" do novo item
                Expanded(
                  child: TextField(
                    controller: addNovoItem,
                    decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.red),
                        labelText: "Adicionar novo item"),
                  ),
                ),

                //Botao para adicionar novo item a lista
                Container(
                  padding: EdgeInsets.all(5.0),
                  height: 70.0,
                  child: RaisedButton(
                    onPressed: addItem,
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),

          //Lista de itens
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 10.0, right: 12.0),
              itemBuilder: constroiItens,
              itemCount: itemStorage.length,
            ),
          )
        ],
      ),
    );
  }

  //----->>> Construtor de itens de cada Store <<<------
  Widget constroiItens(BuildContext context, int index) {
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),

      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),

      direction: DismissDirection.startToEnd,

      child: Row(children: <Widget>[
        // Item "NOME"
        Expanded(
          child: Text(
            itemStorage[index].nome,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          )
        ),

        //---->>> Quantidade <<--------------
        //Adicionar +1 a quantidade do item
        IconButton(
          icon: Icon(
            Icons.add_circle,
            color: Colors.red,
            size: 30.0,
          ),
          onPressed: () {
            int valorIncrementado =
                int.parse(_controllersQuantidade[index].text) + 1;
            _controllersQuantidade[index].text = valorIncrementado.toString();
            itemStorage[index].quantidade = valorIncrementado;

            //Dando upgrade no "DB"
            var id = controllerDB.alterandoQuantidadeDeItem(itemStorage[index]);
          },
        ),

        //Número de itens
        Container(
            padding: EdgeInsets.only(left: 2.5, right: 2.5),
            width: 50.0,
            height: 25.0,
            child: TextField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                controller: _controllersQuantidade[index],
                onChanged: (quantidadeAlterada) {
                  _controllersQuantidade[index].text = quantidadeAlterada;
                  itemStorage[index].quantidade =
                      int.parse(_controllersQuantidade[index].text);
                  //Dando upgrade no "DB"
                  var id = controllerDB
                      .alterandoQuantidadeDeItem(itemStorage[index]);
                })),

        //Diminuir +1 a quantidade do item
        IconButton(
          icon: Icon(
            Icons.remove_circle,
            color: Colors.red,
            size: 30.0,
          ),
          onPressed: () {
            int valorIncrementado =
                int.parse(_controllersQuantidade[index].text) - 1;
            _controllersQuantidade[index].text = valorIncrementado.toString();
            itemStorage[index].quantidade = valorIncrementado;

            //Dando upgrade no "DB"
            var id = controllerDB.alterandoQuantidadeDeItem(itemStorage[index]);
          },
        )
        //----------------------------------------------------------
      ]),

      //Removendo item
      onDismissed: (direction) {
        _itemRemovido = itemStorage[index];
        _indexItemRemovido = index;
        itemStorage.removeAt(_indexItemRemovido);
        _controllersQuantidade.removeAt(_indexItemRemovido);

        //Removendo do "DB"
        var id = controllerDB.deletandoItem(_itemRemovido);
        print(id);

        //Adicionando um SnackBar para desfazer o delete do item
        final snack = SnackBar(
          content: Text(" Item \"${_itemRemovido.nome}\" removido"),
          action: SnackBarAction(
              label: "Desfazer",
              onPressed: () {
                setState(() {
                  //Restaurando item e controller de quantidade
                  itemStorage.insert(_indexItemRemovido, _itemRemovido);
                  _controllersQuantidade.insert(
                      _indexItemRemovido, new TextEditingController());
                  _controllersQuantidade[_indexItemRemovido].text =
                      itemStorage[_indexItemRemovido].quantidade.toString();
                  //Salvando no "DB" novamente
                  id = controllerDB.salvandoNovoItem(_itemRemovido);
                });
              }),
          duration: Duration(seconds: 2),
        );

        Scaffold.of(context).removeCurrentSnackBar();
        Scaffold.of(context).showSnackBar(snack);
      },
    );
  }
  //---------------------------------------------------------

  //Função adicionando item no store
  void addItem() async {
    Item itemNovo = new Item();
    itemNovo.storage = _rotulo;
    itemNovo.nome = addNovoItem.text;
    itemNovo.quantidade = 0;
    addNovoItem.text = "";
    setState(() {
      itemStorage.add(itemNovo);
      _controllersQuantidade.add(new TextEditingController());
      _controllersQuantidade[_controllersQuantidade.length - 1].text =
          itemNovo.quantidade.toString();
    });

    itemNovo.id = await controllerDB.salvandoNovoItem(itemNovo);
    //print(itemNovo.id);
  }

  void addControllerQuantidadeParaItens() {
    itemStorage.forEach((item) {
      _controllersQuantidade.add(new TextEditingController());
    });

    for (int tamanho = 0; tamanho < itemStorage.length; tamanho++) {
      _controllersQuantidade[tamanho].text =
          itemStorage[tamanho].quantidade.toString();
    }
  }
}
