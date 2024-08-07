import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'dart:math';
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