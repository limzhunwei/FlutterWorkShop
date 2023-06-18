import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp/models/order_details.dart';
import 'package:fyp/views/loginscreen.dart';
import 'package:intl/intl.dart';

import '../models/constant.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;


class OrderDetailsScreen extends StatefulWidget {
  final User user;
  final receipt_id;
  const OrderDetailsScreen({Key? key, required this.user, this.receipt_id}) : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  List orderList = [];
  String productQuantity = "";
  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  double totalpayable = 0.0;
  var order_date;
  var order_status;
  final df = DateFormat('dd/MM/yyy hh:mm a');

  @override
  void initState() {
    super.initState();
    _orderDetails();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text('Order Details'),
        ),
        body: orderList.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(titlecenter,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              )
            : Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(
                  children: [
                    Expanded(
                        child: GridView.count(
                            crossAxisCount: 1,
                            childAspectRatio: (1 / 1.25),
                            children: List.generate(orderList.length, (index) {
                              return InkWell(
                                  child: Card(
                                      child: Column(
                                      children: [
                                      Flexible(
                                        flex: 6,
                                        child: CachedNetworkImage(
                                      imageUrl: CONSTANTS.server +
                                      "/fyp/assets/products/" +
                                      orderList[index]['prid'].toString() +
                                      '.jpg',
                                        width: resWidth,
                                        placeholder: (context, url) =>
                                            const LinearProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                  ),
                                  const SizedBox(height: 10),
                                  const SizedBox(height: 10),
                                  Flexible(
                                    flex: 4,
                                    child: Column(children: [
                                      Column(children: [
                                        Text("Product Name: " +
                                            orderList[index]['prname'].toString(),
                                              style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                              ),
                                        const SizedBox(height: 10),
                                        Text("Product Price: RM " +
                                            double.parse(orderList[index]
                                                    ['prprice']
                                                    .toString())
                                                .toStringAsFixed(2),
                                                style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                              ),
                                        const SizedBox(height: 10),
                                        Text("Total Quantity: " +
                                            orderList[index]['cartqty'].toString(),
                                              style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                              ),
                                        const SizedBox(height: 10),
                                        Text(
                                          "Total Price: RM " +
                                              double.parse(orderList[index]
                                                      ['price_total']
                                                      .toString())
                                                  .toStringAsFixed(2),
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 10),
                                        Text("Order Status: " +
                                            orderList[index]['cart_status'].toString(),
                                              style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                              ),
                                      ]),
                                    ]),
                                  )
                                ],
                              ))
                              );
                            }))),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Total Payment: RM " + totalpayable.toStringAsFixed(2),
                                  style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Order Date: " + df.format(DateTime.parse(order_date)),
                                  style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 5),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )));
  }

  void _orderDetails(){
  http.post(Uri.parse(CONSTANTS.server + "/fyp/php/load_order_details.php"),
    body: {
      "email": widget.user.email, "receipt_id": widget.receipt_id
    }).then((response){
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success'){
        print(response.body);
        var extractdata = data['data'];
        var total = data['total'];
        setState((){
          orderList = extractdata["order"];
          totalpayable = total.toDouble();
          order_date = data["order_date"];
        });
      } else{
        setState((){
          titlecenter = "No Data";
        });
       }
    });
   }

}