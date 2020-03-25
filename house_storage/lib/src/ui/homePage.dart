import 'package:flutter/material.dart';
import 'package:house_storage/src/ui/build/storage.dart';


class Home extends StatefulWidget{
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>{
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("HouseStore",
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),

      backgroundColor: Color.fromRGBO(255,99,71, 0.8),

      body: Column(
        
        children: <Widget>[
        
        //--> COZINHA
        new Storage().construiStore('Cozinha', context),

        //---> LAVANDERIA
        new Storage().construiStore('Lavanderia', context),

        //---> QUARTO
        new Storage().construiStore('Quarto', context),
        
        //---> BANHEIRO
        new Storage().construiStore('Banheiro', context)
        ],
      ),
    );
  }
  
}
