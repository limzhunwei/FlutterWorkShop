import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fyp_expert/views/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Herbs Repository (Expert)',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: const MySplashScreen(title: 'Herbs Repository (Expert)'),
    );
  }
}

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key, required String title}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  void initState(){
    super.initState();
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (content) => const LoginScreen())
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/splash_screen.png'),
                  fit: BoxFit.cover
                )
              )),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  CircularProgressIndicator(),
                ],
              ),
            ),
          ],
        ),
    );
  }
}