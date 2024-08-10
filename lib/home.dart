import 'dart:math';

import 'package:appetici/func.dart';
import 'package:flutter/material.dart';
import 'TestPage.dart';


class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _HomePageState();

}



class _HomePageState extends State<HomePage>{
  int page = 0;
  late Widget pageToDisplay;

  callback(varPage){
    setState(() {
      page = varPage;
    });
  }
  int N_DOMANDE = 0;
  List<int> domandePerTipo = [0,0,0,0];

  selezionaDomande(int N_DOMANDE,List<int> domandePerTipo){
    setState(() {
        this.N_DOMANDE = N_DOMANDE;
        this.domandePerTipo = domandePerTipo;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch(page){
      case 0:  pageToDisplay = LogInPage(callback: callback, selezionaDomande : selezionaDomande);
      case 1:
        if(N_DOMANDE == 0){
          break;
        }
        List<int> domande;
        if((domandePerTipo[0]+domandePerTipo[1] + domandePerTipo[2] + domandePerTipo[3]) == 0) {
          domande = creaDomande(N_DOMANDE, TIPOLOGIA.ALL);
        }else{
          domande = creaDomande(domandePerTipo[0], TIPOLOGIA.SOC);
          domande.addAll(creaDomande(domandePerTipo[1], TIPOLOGIA.ECO));
          domande.addAll(creaDomande(domandePerTipo[2], TIPOLOGIA.LEG));
          domande.addAll(creaDomande(domandePerTipo[3], TIPOLOGIA.ETH));
          domande.shuffle(new Random());
        }
        print(domande);
        pageToDisplay = TestPage(callback: callback,domande: domande,n_domande: N_DOMANDE);
      default:
        throw UnimplementedError('no widget for $page');
    }
    return pageToDisplay;
  }
}

class LogInPage extends StatefulWidget {
  const LogInPage({
    super.key,
    required this.callback, required Function(int N_DOMANDE, List<int> domandePerTipo) this.selezionaDomande
  });
  final Function callback;
  final Function selezionaDomande;
  @override
  State<StatefulWidget> createState() => _LogInPage(callback: callback, selezionaDomande: selezionaDomande);

}

class _LogInPage extends State<LogInPage> {
  final Function callback;
  final Function  selezionaDomande;
  _LogInPage({
    required this.callback, required Function this.selezionaDomande
  });
  int N_DOMANDE = 0;
  List<int> domandePerTipo = [0,0,0,0];
  bool showWidget = true;
  List<List<int>> numeroDiDomande = [[0,N_DOMANDE_TOTALE],
    [0,N_DOMANDE_SOC],[0,N_DOMANDE_ECO],[0,N_DOMANDE_LEG],[0,N_DOMANDE_ETH]];
  List<String> label = ["","SOCIALI: ","ECONOMICHE: ","LEGALI: ","ETICHE: "];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0,0,0,0),
          child: Center(child: Text("APPETICI", style: TextStyle(
              color: Colors.white))
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 200),
          Center(
            child: ElevatedButton(
              child: Text("INIZIA"),
              onPressed: () {
                callback(1);
                selezionaDomande(N_DOMANDE,domandePerTipo);
              },
            ),
          ),
          SizedBox(height: 20),
          showWidget
              ? buildSlider(0):
          Column(
            children: [
              buildSlider(1),
              SizedBox(height: 20),
              buildSlider(2),
              SizedBox(height: 20),
              buildSlider(3),
              SizedBox(height: 20),
              buildSlider(4),
            ],
          ),
          Text(
            'Numero domande: $N_DOMANDE',
            style: TextStyle(color: Colors.indigo),
          ),
          showWidget ?
          ElevatedButton(
            child: Text("PERSONALIZZA"),
            onPressed: () {
              setState(() {
                showWidget = false;
                N_DOMANDE = 0;
              });
            },
          ):
          ElevatedButton(
            child: Text("MOSTRA MENO"),
            onPressed: () {
              setState(() {
                showWidget = true;
                domandePerTipo = [0,0,0,0];
                N_DOMANDE = 0;
              });
            },
          ),
        ],
      ),
    );
  }

  Slider buildSlider(int i) {
    int valore = N_DOMANDE;
    if(i != 0){
      valore = domandePerTipo[i-1];
    }
    return Slider(
              min: 0,
              max: numeroDiDomande[i][1].toDouble(),
              divisions: 100,
              value: valore.toDouble(),
              label: "${label[i]} ${valore.round()}",
              onChanged: (value) {
                setState(() {
                  if(i == 0) {
                    N_DOMANDE = value.toInt();
                  }else{
                    domandePerTipo[i-1] = value.toInt();
                    N_DOMANDE = domandePerTipo[0] +domandePerTipo[1]+
                        domandePerTipo[2] + domandePerTipo[3];
                  }
                });
              },
            );
  }
}