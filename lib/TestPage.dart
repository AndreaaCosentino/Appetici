import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'func.dart';
import 'wrongAnswersDisplay.dart';
import 'main.dart';

class TestPage extends StatefulWidget {
  final Function callback;

  TestPage({
    super.key,
    required this.callback
  });
  int n_domande = N_DOMANDE;
  @override
  State<TestPage> createState() => _TestPage(callback: callback, numero: n_domande,domande: creaDomande(n_domande));
}

class _TestPage extends State<TestPage> {
  final Function callback;
  final List<int> domande;
  final int numero;
  final List<int> risposteSbagliate = [];

  _TestPage({
    required this.callback,
    required this.numero,
    required this.domande
  });


  @override
  Widget build(BuildContext context) {
    List<List<dynamic>> values = const CsvToListConverter().convert(domanda);
    Random random = new Random();
    int currentQuestion = 0;
    if (domande.isEmpty) {
      return wrongAnswersDisplay(callback: callback,lista: risposteSbagliate);
    }
    String question;
    String correctAnswer;
    List<String> answers = [];
    int id = domande[currentQuestion];
    if (values[id][1] is int)
      question = "$values[$id][1]";
    else
      question = values[id][1];

    int questionOrder = random.nextInt(4);
    for (int i = 0; i < 4; i++) {
      int j = (i + questionOrder) % 4 + 5;
      if (values[currentQuestion][j] is int)
        answers.add("$values[$id][$j]");
      else
        answers.add(values[id][j]);
    }
    int numb = int.parse((values[id][4] as String)[8]);
    correctAnswer = answers[(numb + (4 - questionOrder)) % 4];
    String domandeMancanti = "Mancano ${domande.length.toString()} domande";
    if (domande.length == 1) {
      domandeMancanti = "Manca ${domande.length.toString()} domanda";
    }

    aggiornaStato(bool isCorrect) {
      setState(() {
        if(isCorrect){
          risposteSbagliate.add(domande[0]);
        }
        questionOrder = random.nextInt(4);
        domande.removeAt(0);
      });
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Padding(
            padding: const EdgeInsets.fromLTRB(35,0,0,0),
            child: Center(child: Text(domandeMancanti, style: TextStyle(
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
                  fixedSize: const Size(300, 90),
                  backgroundColor: Colors.indigo,
                  shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0)))),
              child:  Text(question,style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 50),
            buildRisposta(answers[0], callback: aggiornaStato, correctAnswer),
            SizedBox(height: 20),
            buildRisposta(answers[1], callback: aggiornaStato, correctAnswer),
            SizedBox(height: 20),
            buildRisposta(answers[2], callback: aggiornaStato, correctAnswer),
            SizedBox(height: 20),
            buildRisposta(answers[3], callback: aggiornaStato, correctAnswer),
          ],
        ),
      ),
    );
  }
}

ElevatedButton buildRisposta(String answer,String correctAnswer, {required Null Function(bool isCorrect) callback} ) {
  return ElevatedButton(
    child: Text(answer),
    style: ButtonStyle(
      shape:  WidgetStateProperty.all(BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0)))),
      fixedSize: WidgetStateProperty.all(Size(300, 80)),
      backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
          if (states.contains(WidgetState.pressed)) {
            if(answer == correctAnswer) {
              return Colors.green;
            } else {
              return Colors.red;
            }
          }
          return Colors.white;
        },
      ),
    ),
    onPressed: () {
      if(answer != correctAnswer) {
        callback(true);
      }else{
        callback(false);
      }
    },
  );
}