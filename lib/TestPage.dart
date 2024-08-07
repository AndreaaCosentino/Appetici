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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(domandeMancanti),
            ),
            Text(question),
            buildRisposta(answers[0], callback: aggiornaStato, correctAnswer),
            buildRisposta(answers[1], callback: aggiornaStato, correctAnswer),
            buildRisposta(answers[2], callback: aggiornaStato, correctAnswer),
            buildRisposta(answers[3], callback: aggiornaStato, correctAnswer),
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
      ),
    );
  }
}

ElevatedButton buildRisposta(String answer,String correctAnswer, {required Null Function(bool isCorrect) callback} ) {
  return ElevatedButton(
    child: Text(answer),
    style: ButtonStyle(
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