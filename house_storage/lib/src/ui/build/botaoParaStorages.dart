import 'package:flutter/material.dart';
import 'package:house_storage/src/ui/storagePage.dart';
// Botão no qual leva para os diversos stores do app
class BotaoParaStore{

  Widget construtorBotaoAdicionar(String rotulo, BuildContext context){
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
        color: Color.fromRGBO(255,99,71, 1.0),
        border: Border.all(width: 0.8, color: Colors.white)
      ),
      child: GestureDetector(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onTap: (){
          qualStore(context, rotulo);
        }, 
      )
    );
  }

  void qualStore(BuildContext context, String rotulo){

    switch(rotulo){
      
      case "Cozinha":
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => StoragePage(rotulo)
        ));
        break;
      
      case "Quarto":
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => StoragePage(rotulo)
        ));
        break;
      
      case "Lavanderia":
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => StoragePage(rotulo)
        ));
        break;
      
      case "Banheiro":
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => StoragePage(rotulo)
        ));
        break;
    }
  }

}
