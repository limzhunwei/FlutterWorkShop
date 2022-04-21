import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String name = "Lim";
    TextEditingController nameEditingController = TextEditingController();
    
    return MaterialApp(
      title: "Hello World",
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Hellow World",
          ),
        ),
       body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
              const Text("Enter Your Name:"),
              TextField(
                controller: nameEditingController,
              ),
              ElevatedButton(
                onPressed:(){
                  setState(){
                    name = nameEditingController.text;
                  }
              },
                child: Text("Press Me"),
                ),
                Text(name)
              ]
            )
        )
      )
    );
  }
}
