import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beautiful UI with Flutter Workshop',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Beautiful UI with Flutter Workshop'),
        ),
        body: Center(
          child: Container(
            child: const Text('Hello, world!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20, 
              color: Colors.blue
              ),
            ),
          ),
        ),
      ),
    );
  }
}