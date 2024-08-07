import 'package:flutter/services.dart';
import 'dart:math';

const int N_DOMANDE = 16;

Future<String> loadAsset() async{
  var path = 'assets/domandeAspetti.csv';
  final myData = await  rootBundle.loadString(path);
  print(myData);
  return myData;
}

List<int> creaDomande(int N_DOMANDE){
  List<int> domande = [];
  Random random = new Random();
  for(int i = 0; i < N_DOMANDE; i++){
    bool vecchioNumero = true;
    while(vecchioNumero){
      int current =  random.nextInt(296)+1;
      if(!domande.contains(current)){
        domande.add(current);
        vecchioNumero = false;
      }
    }
  }
  return domande;
}
