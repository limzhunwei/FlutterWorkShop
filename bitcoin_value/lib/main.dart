import 'dart:async';

import 'package:flutter/material.dart';

import 'converter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BitCoin Converter',
      theme: ThemeData(primarySwatch: Colors.lime),
      home: Scaffold(
        body: SplashPage(),
      ));
  }
}

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center,
    children: [
      Container(
        alignment: Alignment.bottomCenter,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bitcoin_background.png'),
        fit: BoxFit.cover)),
        
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 570, 0, 120),
        child: Column(
          mainAxisAlignment:MainAxisAlignment.spaceBetween,
          children: const[
            Text(
              "BitCoin Converter",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.limeAccent)
                ),
                CircularProgressIndicator()
          ],)
        )
    ]);
  }
  @override
    void initState() {
      super.initState();
      Timer(
        const Duration(seconds: 3), 
        () => Navigator.pushReplacement(
          context, 
          MaterialPageRoute(
            builder: (content) => Converter())
            ));
    }
}