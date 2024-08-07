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

    setNewPage(){
      setState(() {
        i = (i+1)%lista.length;
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(domandaSbagliata),
              Risposta(Risposte: Risposte,mioIndice: 0,indiceErrata: Indice),
              Risposta(Risposte: Risposte,mioIndice: 1,indiceErrata: Indice),
              Risposta(Risposte: Risposte,mioIndice: 2,indiceErrata: Indice),
              Risposta(Risposte: Risposte,mioIndice: 3,indiceErrata: Indice),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30,20,0,0),
                    child: Text(StringaSotto),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(100,20,0,0),
                    child: ElevatedButton(onPressed: (){
                      CambiaPagina();
                      }, child: Text("AVANTI")),
                  ),
                ],
              ),
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
}

class Risposta extends StatelessWidget {
  const Risposta({
    super.key,
    required this.Risposte, required int this.mioIndice, required int this.indiceErrata,
  });

  final List<String> Risposte;
  final int mioIndice;
  final int indiceErrata;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
                if(mioIndice == indiceErrata) {
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
