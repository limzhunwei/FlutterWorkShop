import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: Center(
          child: Container(
            child: Text('Hello World'),
          ),
        ),
      ),
    );
  }
}

class MyWeatherPage extends StatefulWidget {
  const MyWeatherPage({ Key? key }) : super(key: key);

  @override
  State<MyWeatherPage> createState() => _MyWeatherPageState();
}

class _MyWeatherPageState extends State<MyWeatherPage> {
  @override
String selectLoc = "Changlun";
List<String> locList = ["Korea","Japan","Malaysia"];

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(' Weather APP')),
      body: Center(
        child: Column(
          children: [
            const Text("Simple Weather App", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            DropdownButton(
              itemHeight: 60,
              value: selectLoc,
              items: locList.map((selectLoc),value: selectLoc),
            ),
          ]))
    );
  }
}