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

class LogInPage extends StatefulWidget {
  const LogInPage({
    super.key,
    required this.callback
  });
  final Function callback;
  @override
  State<StatefulWidget> createState() => _LogInPage(callback: callback);

}

class _LogInPage extends State<LogInPage> {
  final Function callback;
  _LogInPage({
    required this.callback
  });

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
              },
            ),
          ),
          Slider(
            min: 1,
            max: 100.0,
            divisions: 100,
            value: N_DOMANDE.toDouble(),
            label: "${N_DOMANDE.round()}",
            onChanged: (value) {
              setState(() {
                N_DOMANDE = value.toInt();
              });
            },
          ),
          Text(
            'Numero domande: $N_DOMANDE',
            style: TextStyle(color: Colors.indigo),
          ),
        ],
      ),
    );
  }
}