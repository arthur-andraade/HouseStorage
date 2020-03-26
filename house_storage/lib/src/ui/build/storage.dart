import 'package:flutter/material.dart';
import 'package:house_storage/src/ui/build/botaoParaStorages.dart';

// Classe dos diversos tipos de stores que tem na HouseStore
// Utilizado na homepageStore
class Storage {

  // Rotulo determina qual Store vai ser produzido
  Widget opcaoStorage(String nomeStorage , BuildContext context){ 
    
    //Layout dos diversos stores
    return Center(

          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 2.0, style: BorderStyle.solid, color: Colors.white),
                borderRadius: BorderRadius.circular(8.0),
                color:  Colors.red
              ),

              padding: EdgeInsets.all(5.0),
              child: SizedBox(
                width: 100.0,
                height: 80.0,

                child: Column(
                  children: <Widget>[
                    Text( nomeStorage,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    
                    // BOTÃO ADICIONAR -> PageStore de acordo com "rotulo"
                    Padding(
                      padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 3.0),
                      child: new BotaoParaStorage().construtorBotaoParaEntrar(nomeStorage, context) //Botão que leva as page especificas dos stores
                    )
                  ],
                )
                
              ),
            ),
          ),
        );
  }
}
