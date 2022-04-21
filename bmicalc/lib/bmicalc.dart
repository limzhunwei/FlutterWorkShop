import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() => runApp(BmiCalcPage());




class BmiCalcPage extends StatelessWidget {
  const BmiCalcPage({Key? key}) : super(key: key);
   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      home: Scaffold(
        appBar: AppBar(
          title: Text('BMI Calculator'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 200,
              child: Center(
                child: Image.asset('assets/images/bmi.jpg', scale: 1))
              ),
              Container(
                child: BmiCalcForm(),
              )
            ],
        ),
      ),
    ));
  }
}



class BmiCalcForm extends StatefulWidget {
  const BmiCalcForm({ Key? key }) : super(key: key);

  @override
  State<BmiCalcForm> createState() => _BmiCalcFormState();
}

class _BmiCalcFormState extends State<BmiCalcForm> {
  TextEditingController heightEditingController = TextEditingController();
  TextEditingController weightEditingController = TextEditingController();
  double height = 0.0, weight = 0.0, bmi = 0.0;
  AudioCache audioChace = new AudioCache();
  AudioPlayer audioPlayer = new AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20,0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text("BMI Calculator", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: heightEditingController, 
              keyboardType: const TextInputType.numberWithOptions(), 
              decoration: InputDecoration(
                hintText: "Height in Meter", 
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0))),
                  ),
            const SizedBox(height: 10),
            TextField(
              controller: weightEditingController, 
              keyboardType: const TextInputType.numberWithOptions(), 
              decoration: InputDecoration(
                hintText: "Weight in kg", 
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0))),
                  ),
            const SizedBox(height:10),
            ElevatedButton(onPressed: _calBMI, child: const Text("CalculateBMI")),
            const SizedBox(height:10),
            Text("Your BMI is " + bmi.toStringAsPrecision(3),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
          ],
        ),
      )
    );
  }

  void _calBMI() {
    height = double.parse(heightEditingController.text);
    weight = double.parse(weightEditingController.text);
    setState((){
      bmi = weight / (height * height);
      loadOk();
    });
  }

  void loadOk() async {
    audioPlayer = await AudioCache().play("audios/blueming.mp3");
  }

 
}

