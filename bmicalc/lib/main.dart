import 'dart:async';

import 'package:flutter/material.dart';

import 'bmicalc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Material App",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashPage()
      );
  
  }
  
}

class SplashPage extends StatefulWidget {
  const SplashPage({ Key? key }) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState(){
    super.initState();
    Timer(const Duration(seconds: 3), () => Navigator.pushReplacement(context,
    MaterialPageRoute(builder: (content) => BmiCalcPage())));
  }
  
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/bmi logo.png', scale: 0.5),
            const Text("BMI CALCULATOR", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.amber)
            )
            ],)
      ),
    );
  }
}