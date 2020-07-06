import 'package:flutter/material.dart';
import 'package:house_storage/src/ui/pages/home_page.dart';


void main(){
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "HouseStorage",
    home: Home(),
    theme: ThemeData(
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red), borderRadius: BorderRadius.all(Radius.circular(20.0))),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(255, 99, 71, 1)))
      )
    )
  ));
}
