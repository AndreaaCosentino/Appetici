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
    List<String> answers = [];

    if(values[randomNumber][1] is int)
      question = "$values[randomNumber][1]";
    else question = values[randomNumber][1];

    if(values[randomNumber][5] is int)
      answers.add("$values[randomNumber][5]");
    else answers.add(values[randomNumber][5]);

    if(values[randomNumber][6] is int)
      answers.add("$values[randomNumber][6]");
    else answers.add(values[randomNumber][6]);

    if(values[randomNumber][7] is int)
      answers.add("$values[randomNumber][7]");
    else answers.add(values[randomNumber][7]);

    if(values[randomNumber][8] is int)
      answers.add("$values[randomNumber][8]");
    else answers.add(values[randomNumber][8]);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(question),
            ElevatedButton(
              child: Text(answers[0]),
              onPressed: () {
                setState(() {
                  randomNumber = random.nextInt(296)+1;
                });
              },
            ),
            ElevatedButton(
              child: Text(answers[1]),
              onPressed: () {
                setState(() {
                  randomNumber = random.nextInt(296)+1;
                });
              },
            ),
            ElevatedButton(
              child: Text(answers[2]),
              onPressed: () {
                setState(() {
                  randomNumber = random.nextInt(296)+1;
                });
              },
            ),
            ElevatedButton(
              child: Text(answers[3]),
              onPressed: () {
                setState(() {
                  randomNumber = random.nextInt(296)+1;
                });
              },
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
      ),
    );
  }
}

Future<String> loadAsset() async{
  var path = 'assets/domandeAspetti.csv';
  final myData = await  rootBundle.loadString(path);
  print(myData);
  return myData;
}


