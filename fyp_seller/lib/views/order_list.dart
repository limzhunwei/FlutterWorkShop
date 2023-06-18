import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../models/cart.dart';
import '../models/order.dart';

import '../models/constant.dart';
import 'package:http/http.dart' as http;

import '../models/seller.dart';

class OrderListScreen extends StatefulWidget {
  final Seller seller;
  const OrderListScreen({super.key, required this.seller});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  List<Order> orderList = <Order>[];
  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  final df = DateFormat('dd/MM/yy hh:mm a');
  var numofpage, curpage = 1, color;
  var status = ['All','Paid', 'Delivered'];
  List<bool> _isPressedList = [true, false, false];

  @override
  void initState() {
    super.initState();
    _loadOrders(1, "");
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
        title: const Text('My Orders'),
      ),
      body: orderList.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(titlecenter,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(children: [
                  const Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                    child: Text("Order List",
                        style: TextStyle(
                            fontSize: 20, 
                            fontWeight: FontWeight.bold)),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: status.asMap().entries.map((entry) {
                        final index = entry.key;
                        final char = entry.value;
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, 
                              backgroundColor: _isPressedList[index] 
                              ? Colors.lightBlue 
                              : Colors.grey,
                            ),
                            child: Text(char),
                            onPressed: () {
                              _loadOrders(1, char);
                              setState(() {
                                _isPressedList = List.filled(status.length, false);
                                _isPressedList[index] = true;
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                        child: GridView.count(
                            crossAxisCount: 1,
                            childAspectRatio: (1 / 0.4),
                            children: List.generate(orderList.length, (index) {
                              return Card(
                                elevation: 5,
                                child: InkWell(
                                  onTap: () {
                                    _onOrderDetails(index);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: orderList[index].cart_status.toString().contains('DELIVERED')
                                      ? Color.fromARGB(255, 184, 246, 216)
                                      : Color.fromARGB(255, 250, 189, 189),
                                      borderRadius: BorderRadius.circular(10.0),
                                      ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(20, 10, 20, 0),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Table(
                                              columnWidths: const {
                                                0: FlexColumnWidth(3),
                                                1: FlexColumnWidth(7),
                                              },
                                              border: const TableBorder(
                                                  verticalInside: BorderSide(
                                                      width: 2,
                                                      color: Colors.black,
                                                      style: BorderStyle.solid)),
                                              children: [
                                                TableRow(children: [
                                                  const TableCell(
                                                    child: Text(
                                                      "Receipt ID",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 10.0),
                                                      child: Text(
                                                        orderList[index]
                                                            .receipt_id
                                                            .toString(),
                                                        style: const TextStyle(
                                                          fontSize: 15),
                                                      ),
                                                    ),
                                                  )
                                                ]),
                                                TableRow(children: [
                                                  const TableCell(
                                                    child: Text(
                                                      "Paid",
                                                      style: TextStyle(
                                                        fontSize: 15, 
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 10.0),
                                                      child: Text(
                                                        "RM " +
                                                            orderList[index].amount_paid
                                                                .toString(),
                                                          style: const TextStyle(
                                                          fontSize: 15),
                                                      ),
                                                    ),
                                                  )
                                                ]),
                                                TableRow(children: [
                                                  const TableCell(
                                                    child: Text(
                                                      "Status",
                                                      style: TextStyle(
                                                        fontSize: 15, 
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 10.0),
                                                      child: Text(
                                                        orderList[index]
                                                            .cart_status
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 15, 
                                                            fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  )
                                                ]),
                                                TableRow(children: [
                                                  const TableCell(
                                                    child: Text(
                                                      "Date",
                                                      style: TextStyle(
                                                          fontSize: 15, 
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 10.0),
                                                      child: Text(
                                                        df.format(DateTime.parse(
                                                            orderList[index]
                                                                .order_date
                                                                .toString())),
                                                        style: const TextStyle(
                                                          fontSize: 15),
                                                      ),
                                                    ),
                                                  )
                                                ]),
                                              ],
                                            ),
                                            const SizedBox(height: 3),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: orderList[index].cart_status.toString().contains('PAID')
                                                  ? Color.fromARGB(255, 168, 207, 239)
                                                  : Color.fromARGB(255, 131, 139, 143),
                                                  elevation: 5,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20.0)),
                                                    minimumSize: const Size(20, 30),),
                                                child: const Text("Order delivered",
                                                style: TextStyle(fontSize: 20),),
                                                onPressed: orderList[index].cart_status.toString().contains('PAID')
                                                ? (){
                                                  _orderDelivered(orderList[index].receipt_id.toString());
                                                } 
                                                : null,
                                              ),
                                            ),
                                          ]),
                                    ),
                                  ),
                                ),
                              );
                            })),
                      )),
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
                                        onPressed: () => {
                                          _loadOrders(index + 1, "")
                                        },
                                        child: Text(
                                          (index + 1).toString(),
                                          style: TextStyle(color: color),
                                        )),
                                    );
                                },
                              ),
                            ),
                ]),
              ),
            ),
    );
  }

  void _loadOrders(int pageno, String status) {
    curpage = pageno;
    numofpage ?? 1;
    http.post(
        Uri.parse(CONSTANTS.server + "/fyp/php/load_seller_order.php"),
        body: {
          'email': widget.seller.email,
          'id': widget.seller.id,
          'pageno': pageno.toString(),
          'status': status,
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
      var extractdata = data['data'];
      if (extractdata['order'] != null) {
        numofpage = int.parse(data['numofpage']);
        orderList = <Order>[];
        extractdata['order'].forEach((v) {
          orderList.add(Order.fromJson(v));
        });
      }} else {
        titlecenter = "No Order available";
      }
      setState(() {});
    });
  }

  _onOrderDetails(int index) {
    List cartList = [];
    http.post(
        Uri.parse(
            CONSTANTS.server + "/fyp/php/load_seller_orderdetails.php"),
        body: {
          'receipt_id': orderList[index].receipt_id.toString(),
          'id': widget.seller.id,
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      print(response.body);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        var extractdata = data['data'];
        cartList = extractdata["order"];
        _loadOrderDetailsDialog(cartList, index);
      }
    });
  }

  void _loadOrderDetailsDialog(List cartList, int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                alignment: FractionalOffset.topRight,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.clear),
                ),
              ),
              const Text('Order Details'),
              Text('Receipt ID: ' + orderList[index].receipt_id.toString()
              +'\nCustomer Name: ' + orderList[index].user_name.toString()
              + '\nCustomer Phone: ' + orderList[index].user_phone.toString()
              + '\nCustomer Address: ' + orderList[index].user_address.toString()
              ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: screenWidth,
                    height: screenHeight/3,
                    child: GridView.count(
                    crossAxisCount: 1,
                    childAspectRatio: (1 / 0.25),
                    children: List.generate(cartList.length, (index) {
                      return Card(
                        child: Column(
                          children: [
                            Text(
                            cartList[index]['prname'].toString(),
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Flexible(
                            flex: 4,
                            child: Column(children: [
                              Column(children: [
                                Text("Quantity: " +
                                    cartList[index]['cartqty'].toString()),
                                Text(
                                  "RM " +
                                      double.parse(cartList[index]
                                              ['price_total']
                                              .toString())
                                          .toStringAsFixed(2),
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ]),
                            ]),
                          ),
                        ],
                      ),
                      );
                    })),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _orderDelivered(String receipt_id) {
    http.post(
        Uri.parse(
            CONSTANTS.server + "/fyp/php/order_delivered.php"),
        body: {
          'receipt_id': receipt_id,
          'id': widget.seller.id,
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      print(response.body);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
              msg: "Order Delivered",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
              setState(() {
                _loadOrders(1, "");
              });
      }
    });
  }
}