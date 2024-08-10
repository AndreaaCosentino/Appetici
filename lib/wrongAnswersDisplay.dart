import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'main.dart';

class wrongAnswersDisplay extends StatefulWidget {
  const wrongAnswersDisplay({
    super.key,
    required this.callback, required List<int> this.lista
  });
  final List<int> lista;
  final Function callback;

  @override
  State<StatefulWidget> createState() => _wrongAnswersDisplay(callback: callback,lista: lista);

}

class _wrongAnswersDisplay extends State<wrongAnswersDisplay>{
  final List<int> lista;
  final Function callback;
  int i = 0;

  _wrongAnswersDisplay({
    required this.callback, required List<int> this.lista
  });



  @override
  Widget build(BuildContext context) {
    if(lista.isEmpty){
      return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("HAI INDOVINATO TUTTE LE RISPOSTE!"),
              ],
            ),
          ),
          bottomNavigationBar: Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              ElevatedButton(
                child: Text("INDIETRO"),
                onPressed: () {
                  callback(0);
                },
              ),
            ],
          )
       );
     }

    setNewPage(bool avanti){
      setState(() {
        if(avanti) {
          i = (i + 1) % lista.length;
        }else{
          i = (i - 1) % lista.length;
        }
      });
    };
    List<List<dynamic>> values = const CsvToListConverter().convert(domanda);
    String domandaSbagliata = values[lista[i]][1];
    List<String> Risposte = [];
    int rispostaGiusta;
    if(i == 0){
      rispostaGiusta = int.parse((values[i][5] as String)[8]);
    }else{
      rispostaGiusta = int.parse((values[i][4] as String)[8]);
    }

    for(int j = 0; j < 4; j++){
      Risposte.add(values[lista[i]][j+5]);
    }
    String sotto = "Domanda ${i+1} di ${lista.length} errate";

    return ToDIsplay(domandaSbagliata: domandaSbagliata, callback: callback, Risposte: Risposte,Indice: rispostaGiusta,CambiaPagina: setNewPage, StringaSotto: sotto);

  }
}

class ToDIsplay extends StatelessWidget {
  const ToDIsplay({
    super.key,
    required this.domandaSbagliata,
    required this.callback, required this.Risposte, required int this.Indice, required this.CambiaPagina, required String this.StringaSotto,
  });

  final String domandaSbagliata;
  final Function callback;
  final List<String> Risposte;
  final int Indice;
  final Function CambiaPagina;
  final String StringaSotto;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Padding(
            padding: const EdgeInsets.fromLTRB(35,0,0,0),
            child: Center(child: Text(StringaSotto, style: TextStyle(
             color: Colors.white))
            ),
          ),
          actions: [
            IconButton(
            //padding: const EdgeInsets.fromLTRB(0,0,10,0),
            icon: Icon(Icons.home, color: Colors.white),
              onPressed: () {
                callback(0);
              },
            )
      ],

      ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(300, 100),
                    backgroundColor: Colors.indigo,
                    shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0)))),
                child:  Text(domandaSbagliata,style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 40),
              Risposta(Risposte: Risposte,mioIndice: 0,indiceGiusta: Indice),
              SizedBox(height: 20),
              Risposta(Risposte: Risposte,mioIndice: 1,indiceGiusta: Indice),
              SizedBox(height: 20),
              Risposta(Risposte: Risposte,mioIndice: 2,indiceGiusta: Indice),
              SizedBox(height: 20),
              Risposta(Risposte: Risposte,mioIndice: 3,indiceGiusta: Indice),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40,20,0,0),
                    child: ElevatedButton(onPressed: (){
                      CambiaPagina(false);
                    }, child: Text("INDIETRO")),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(110,20,0,0),
                    child: ElevatedButton(onPressed: (){
                      CambiaPagina(true);
                      }, child: Text("AVANTI")),
                  ),
                ],
              ),
            ],
          ),
        ),
    );
  }
}

class Risposta extends StatelessWidget {
  const Risposta({
    super.key,
    required this.Risposte, required int this.mioIndice, required int this.indiceGiusta,
  });

  final List<String> Risposte;
  final int mioIndice;
  final int indiceGiusta;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          shape:  WidgetStateProperty.all(BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0)))),
          maximumSize: WidgetStateProperty.all(Size(350, 140)),
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
                if(mioIndice == indiceGiusta) {
                  return Colors.green;
                }else{
                  return Colors.white;
                }
            },
          ),
        ),
        onPressed: (){},
        child: Text(Risposte[mioIndice])

    );
  }
}
