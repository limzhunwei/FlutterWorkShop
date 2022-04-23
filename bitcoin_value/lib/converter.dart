import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(Converter());

class Converter extends StatefulWidget {
  @override
  State<Converter> createState() => _ConverterState();
}

class _ConverterState extends State<Converter> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BitCoin Converter',
       theme: ThemeData(primarySwatch: Colors.lime),
      home: Scaffold(
        appBar: AppBar(
          title: Text('BitCoin Converter'),
        ),
        body: const MainPage(),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({ Key? key }) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TextEditingController BitCoinEditingController = TextEditingController();

  var name = 'Crypto/Fiat/Commodity Money', unit = '', value = 0.00, exchangedValue = 0.00, getValue = 0.00;

  List<String> currency = ['Crypto', 'Fiat', 'Commodity'];
  List<String> rate = [];
  
  String? selectedCurrency;
  String? selectedRate;

  List<String> crypto = ['btc','eth','ltc','bch','bnb','eos','xrp','xlm','link','dot','yfi','bits','sats'];

  List<String> fiat = ['usd','aed','ars','aud','bdt','bhd','bmd','brl','cad','chf','clp','cny','czk','dkk',
  'eur','gbp','hkd','huf','idr','ils','inr','jpy','krw','kwd','lkr','mmk','mxn','myr','ngn','nok','nzd',
  'php','pkr','pln','rub','sar','sek','Ssgd','thb','try','twd','uah','vef','vnd','zar','xdr'];

  List<String> commodity = ['xag','xau'];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset('assets/images/bitcoin_logo.png', scale: 4),
            const SizedBox(height: 40),

            const Text('BitCoin Cryptocurrency Value Converter', 
            style: TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),

              TextField(
                controller: BitCoinEditingController, 
                keyboardType: const TextInputType.numberWithOptions(), 
                decoration: InputDecoration(
                  hintText: 'BitCoin (BTC)', 
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0))),
                    ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.only(left: 14.0, right: 14),
              child: DropdownButton<String>(
                hint: Text('Select Currency'),
                value: selectedCurrency,
                isExpanded: true,
                items: currency.map((String value){
                  return DropdownMenuItem<String>(
                    child: Text(
                      value,
                      ),
                      value: value,
                      );
                }).toList(),
               onChanged: (currency) {
                  if(currency == 'Crypto'){
                    rate = crypto;
                    }
                    else if (currency == 'Fiat'){
                      rate = fiat;
                      }
                      else if (currency == 'Commodity'){
                        rate = commodity;
                      }
                      else{
                        rate = [];
                        }
                        setState((){
                          selectedRate = null;
                          selectedCurrency = currency;
                        });
                  }
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: DropdownButton<String>(
                hint: Text('Select Rate'),
                value: selectedRate,
                isExpanded: true,
                items: rate.map((String value){
                  return DropdownMenuItem<String>(
                    child: Text(
                      value,
                      ),
                      value: value,
                      );
                }).toList(),
                onChanged: (rate) {
                  setState((){
                    selectedRate = rate;
                  });
                  }
              ),
            ),
            const SizedBox(height: 30),
            
            Text(
                  name.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 25, 
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.limeAccent,
                  ),
              child: Center(
                child: Text(
                  unit.toString() + "\t" + exchangedValue.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 30, 
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    ),
                  ),
              ),
            )
            ),
             const SizedBox(height: 30),

            ElevatedButton(
              onPressed: _ExchangedValue, 
              child: const Text('EXCHANGE')
              ),
            ],
          ),
      ),
    );
  }

  void _ExchangedValue() async{
    getValue = double.parse(BitCoinEditingController.text);

    var url = Uri.parse('https://api.coingecko.com/api/v3/exchange_rates');
    var response = await http.get(url);
    if(response.statusCode == 200){
      var jsonData = response.body;
      var parsedData = json.decode(jsonData);

      setState((){
        name = parsedData['rates'][selectedRate]['name'];
        unit = parsedData['rates'][selectedRate]['unit'];
        value = parsedData['rates'][selectedRate]['value'];
        exchangedValue = getValue*value;
      });
    }
  }
}