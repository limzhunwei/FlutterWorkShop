import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp/views/loginscreen.dart';
import 'package:fyp/views/order_details.dart';
import 'package:intl/intl.dart';

import '../models/order.dart';
import '../models/constant.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;


class OrderScreen extends StatefulWidget {
  final User user;
  const OrderScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<Order> orderList = <Order>[];
  String subjectQuantity = "";
  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  double totalpayable = 0.0;
  var numofpage, curpage = 1, color;
  final df = DateFormat('dd/MM/yyy hh:mm a');

  @override
  void initState() {
    super.initState();
    _loadOrder(1);
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
          title: const Text('My Order'),
          actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () {
              _signOut();
            },
          ),
        ],
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
                            childAspectRatio: (1 / 0.5),
                            children: List.generate(orderList.length, (index) {
                              return InkWell(
                                  child: Card(
                                    child: Column(children: [
                                      Column(children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text("Receipt ID: " +
                                              orderList[index].receipt_id.toString() +
                                              "\n\n" +
                                              "Total Product Ordered: " +
                                              orderList[index].total_qty .toString() +
                                              "\n\n" +
                                              "Order Date: " +
                                              df.format(DateTime.parse(orderList[index].order_date .toString() )) +
                                              "\n\n" ,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                              ),
                                          const SizedBox(height: 10),
                                          ],  
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const SizedBox(height: 40),
                                            GestureDetector(
                                              onTap: () => {_loadOrderDetails(index),},
                                                child: const Text( "View Order",
                                                style: TextStyle(
                                                  decoration: TextDecoration.underline,
                                                  fontSize: 17),)
                                                  ),
                                          ],
                                        )
                                      ]),
                                    ]),
                              )
                              );
                            }))),
                            SizedBox(
              height: 30,
              child: ListView.builder(
              shrinkWrap: true,
              itemCount: numofpage,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                if ((curpage - 1) == index) {
                  color = Colors.lightBlue;
                  } else {
                    color = Colors.black;
                    }
                    return SizedBox(
                      width: 40,
                      child: TextButton(
                        onPressed: () => {_loadOrder(index + 1)},
                        child: Text(
                          (index + 1).toString(),
                          style: TextStyle(color: color),
                          )),
                    );
                },
                ),
              ),
                  ],
                )));
  }

  void _loadOrder(int pageno) {
    curpage = pageno;
    numofpage ?? 1;
    http.post(
        Uri.parse(CONSTANTS.server + "/fyp/php/load_order.php"),
        body: {
          'pageno': pageno.toString(),
          'email': widget.user.email,
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        titlecenter = "Timeout Please retry again later";
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        numofpage = int.parse(jsondata['numofpage']);
        if (extractdata['order'] != null) {
          orderList = <Order>[];
          extractdata['order'].forEach((v) {
            orderList.add(Order.fromJson(v));
          });
          setState(() {});
        }
      } else {
        titlecenter = "Your Don't Have Any Order 😞 ";
        orderList.clear();
        setState(() {});
      }
    });
  }

    void _signOut() {
      Fluttertoast.showToast(
        msg: "Sign Out Success",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 16.0);    
        Navigator.pushReplacement(
          context, MaterialPageRoute(
            builder: (context) => const LoginScreen()));
      }

  void _loadOrderDetails(int index) {
    String _receipt_id = orderList[index].receipt_id.toString();
    http.post(
          Uri.parse(CONSTANTS.server + "/fyp/php/load_order_details.php"),
          body: {"email": widget.user.email, "receipt_id": _receipt_id}).then((response) {
          var data = jsonDecode(response.body);
          if (response.statusCode == 200 && data['status'] == 'success') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (content) => OrderDetailsScreen(
                        user: widget.user, receipt_id: _receipt_id,
                      )));
        }});
  }
}