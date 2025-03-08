import 'package:flutter/material.dart';
import 'input_screen.dart';
void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'NFA to DFA Converter',
      home: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          title: Text("NFAs to DFA converter", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          centerTitle: true,
          backgroundColor: Colors.blue.shade500,
        ),
        body: HomePage(),
      ),
    );
  }
  
}