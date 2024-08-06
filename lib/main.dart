import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'dart:math';

String domanda = "test";
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Future<String> data = loadAsset();
  domanda = await data;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

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

  @override
  Widget build(BuildContext context) {
    switch(page){
      case 0:  pageToDisplay = LogInPage(callback: callback);
      case 1:  pageToDisplay = TestPage(callback: callback);
      default:
        throw UnimplementedError('no widget for $page');
    }
    return pageToDisplay;
  }
}

class LogInPage extends StatelessWidget {
  final Function callback;
  LogInPage({
    super.key,
    required this.callback
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
          child: Text("INIZIA"),
            onPressed: () {
              callback(1);
            },
         ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Appetici"),
        ],
      ),
      );
  }
}

class TestPage extends StatefulWidget {
  final Function callback;
  TestPage({
    super.key,
    required this.callback
  });
  @override
  State<TestPage> createState() => _TestPage(callback: callback);
}

class _TestPage extends State<TestPage>{
  final Function callback;
  _TestPage({
    required this.callback
  });


  @override
  Widget build(BuildContext context) {
    List<List<dynamic>> values = const CsvToListConverter().convert(domanda);
    Random random = new Random();
    int randomNumber = random.nextInt(296)+1;
    print(randomNumber);
    String question;
    String correctAnswer;
    List<String> answers = [];

    if(values[randomNumber][1] is int)
      question = "$values[randomNumber][1]";
    else question = values[randomNumber][1];

    int questionOrder = random.nextInt(4);
    for(int i = 0; i < 4; i++){
      int j = (i+questionOrder)%4 + 5;
      if(values[randomNumber][j] is int)
        answers.add("$values[randomNumber][$j]");
      else answers.add(values[randomNumber][j]);
    }
    int numb = int.parse((values[randomNumber][4] as String)[8]);
    correctAnswer = answers[(numb + (4-questionOrder))%4];

    aggiornaStato(){
      setState(() {
        questionOrder = random.nextInt(4);
        randomNumber = random.nextInt(296)+1;
      });
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(question),
            buildRisposta(answers[0],callback: aggiornaStato,correctAnswer),
            buildRisposta(answers[1],callback: aggiornaStato,correctAnswer),
            buildRisposta(answers[2],callback: aggiornaStato,correctAnswer),
            buildRisposta(answers[3],callback: aggiornaStato,correctAnswer),
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

  ElevatedButton buildRisposta(String answer,String correctAnswer, {required Null Function() callback}) {
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
              callback();
            },
          );
  }
}

Future<String> loadAsset() async{
  var path = 'assets/domandeAspetti.csv';
  final myData = await  rootBundle.loadString(path);
  print(myData);
  return myData;
}


