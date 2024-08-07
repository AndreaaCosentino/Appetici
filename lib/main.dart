import 'package:flutter/material.dart';
import 'home.dart';
import 'func.dart';

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

