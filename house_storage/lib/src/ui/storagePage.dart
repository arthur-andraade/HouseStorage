import 'package:house_storage/src/model/item.dart';
import 'package:flutter/material.dart';
import 'package:house_storage/src/model/help/storage_help.dart';

class StoragePage extends StatefulWidget {
  String _storageSelecionado;

  StoragePage(String storageSelecionado) {
    this._storageSelecionado = storageSelecionado;
  }

  _StorageState createState() => _StorageState(this._storageSelecionado);
}

class _StorageState extends State<StoragePage> {
  
  String _storageSelecionado;
  TextEditingController addNovoItem = new TextEditingController();

  Storage_help controllerDB = Storage_help();

  List<Item> itemStorage = List();
  List<TextEditingController> _controllersQuantidade = List();
  List<TextEditingController> _controllersNome = List();

  Item _itemRemovido;
  int _indexItemRemovido;

  _StorageState(String storageSelecionado) {
    this._storageSelecionado = storageSelecionado;
  }

  @override
  void initState() {
    super.initState();

    controllerDB.setRotulo(_storageSelecionado);
    controllerDB.getTodosItens().then((listaDeItens) {
      setState(() {
        itemStorage = listaDeItens;
        addControllerQuantidadeENomeParaItens();
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('$_storageSelecionado'),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),

      body: Column(
        
        children: <Widget>[
        
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: <Widget>[

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child:Container(
                      height: 70.0,
                      padding: EdgeInsets.all(5.0),
                      child:TextField(
                        controller: addNovoItem,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.red),
                          labelText: "Adicionar novo item",
                          border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  ),
                ),
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
        
        Expanded(
          child: Padding(padding: EdgeInsets.only(left: 15.0, right: 5.0),
            child: TextField(
              controller: _controllersNome[index],
              keyboardType: TextInputType.text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent
              ),
              decoration: null,
            
              onChanged: (nomeAlterado){
                
                _controllersNome[index].text = nomeAlterado;
                itemStorage[index].nome = _controllersNome[index].text;
                
            
                var id = controllerDB.alterandoNomeDoItem(itemStorage[index]);
              },
            )
          )
        ),

        IconButton(
          icon: Icon(
            Icons.add_circle,
            color: Colors.red,
            size: 30.0,
          ),
          onPressed: () {
            int valorIncrementado = int.parse(_controllersQuantidade[index].text) + 1;
            _controllersQuantidade[index].text = valorIncrementado.toString();
            itemStorage[index].quantidade = valorIncrementado;

            var id = controllerDB.alterandoQuantidadeDeItem(itemStorage[index]);
          },
        ),
        
        Container(
            padding: EdgeInsets.only(left: 2.5, right: 2.5),
            width: 50.0,
            height: 25.0,
            child: TextField(
                autofocus: true,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
                controller: _controllersQuantidade[index],
                decoration: null,
    
                onChanged: (quantidadeAlterada) {
                  
                  _controllersQuantidade[index].text = quantidadeAlterada;
                  itemStorage[index].quantidade =
                      int.parse(_controllersQuantidade[index].text);
                  
                
                  var id = controllerDB.alterandoQuantidadeDeItem(itemStorage[index]);

                })),

        IconButton(
          icon: Icon(
            Icons.remove_circle,
            color: Colors.red,
            size: 30.0,
          ),
          
          onPressed: () {
            int valorIncrementado = int.parse(_controllersQuantidade[index].text) - 1;
            _controllersQuantidade[index].text = valorIncrementado.toString();
            itemStorage[index].quantidade = valorIncrementado;

            var id = controllerDB.alterandoQuantidadeDeItem(itemStorage[index]);
          },
        )
        
      ]),

    
      onDismissed: (direction) {
        
        _itemRemovido = itemStorage[index];
        _indexItemRemovido = index;
        itemStorage.removeAt(_indexItemRemovido);

        _controllersQuantidade.removeAt(_indexItemRemovido);
        _controllersNome.removeAt(_indexItemRemovido);
  
        var id = controllerDB.deletandoItem(_itemRemovido);
     
        final snack = SnackBar(
          content: Text(" Item \"${_itemRemovido.nome}\" removido"),
          action: SnackBarAction(
              label: "Desfazer",
              onPressed: () {
                setState(() {
              
                  itemStorage.insert(_indexItemRemovido, _itemRemovido);

                  _controllersQuantidade.insert(_indexItemRemovido, new TextEditingController());
                  _controllersQuantidade[_indexItemRemovido].text = itemStorage[_indexItemRemovido].quantidade.toString();

                  _controllersNome.insert(_indexItemRemovido, new TextEditingController());
                  _controllersNome[_indexItemRemovido].text = itemStorage[_indexItemRemovido].nome;
                  
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

  void addItem() async {
    
    Item itemNovo = new Item();
    itemNovo.storage = _storageSelecionado;
    itemNovo.nome = addNovoItem.text;
    itemNovo.quantidade = 0;
    addNovoItem.text = "";

    setState(() {
      itemStorage.add(itemNovo);
      _controllersQuantidade.add(new TextEditingController());
      _controllersNome.add(new TextEditingController());

      _controllersQuantidade[_controllersQuantidade.length - 1].text = itemNovo.quantidade.toString();
      _controllersNome[_controllersNome.length - 1].text = itemNovo.nome;
    });

    itemNovo.id = await controllerDB.salvandoNovoItem(itemNovo);
    
  }

  void addControllerQuantidadeENomeParaItens() {
    
    itemStorage.forEach((item) {
      _controllersQuantidade.add(new TextEditingController());
      _controllersNome.add(new TextEditingController());
    });

    for (int tamanho = 0; tamanho < itemStorage.length; tamanho++) {
      _controllersQuantidade[tamanho].text =
          itemStorage[tamanho].quantidade.toString();
      _controllersNome[tamanho].text = itemStorage[tamanho].nome;
    }
  }
}
