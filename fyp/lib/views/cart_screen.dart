import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp/views/loginscreen.dart';
import 'package:fyp/views/payment_screen.dart';

import '../models/cart.dart';
import '../models/constant.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;


class CartScreen extends StatefulWidget {
  final User user;
  const CartScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Cart> cartList = <Cart>[];
  String productQuantity = "";
  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  double totalpayable = 0.0;

  @override
  void initState() {
    super.initState();
    _loadCart();
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
          title: const Text('My Cart'),
          actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () {
              _signOut();
            },
          ),
        ],
        ),
        body: cartList.isEmpty
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
                            childAspectRatio: (1 / 1),
                            children: List.generate(cartList.length, (index) {
                              return InkWell(
                                  child: Card(
                                      child: Column(
                                      children: [
                                      Flexible(
                                        flex: 6,
                                        child: CachedNetworkImage(
                                      imageUrl: CONSTANTS.server +
                                      "/fyp/assets/products/" +
                                      cartList[index].prid.toString() +
                                      '.jpg',
                                        width: resWidth,
                                        placeholder: (context, url) =>
                                            const LinearProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    cartList[index].prname.toString(),
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10),
                                  Flexible(
                                    flex: 4,
                                    child: Column(children: [
                                      Column(children: [
                                        Text("Product Price: RM " +
                                            double.parse(cartList[index]
                                                    .prprice
                                                    .toString())
                                                .toStringAsFixed(2),
                                                style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                              ),
                                        const SizedBox(height: 10),
                                        Text(
                                          "Total Price: RM " +
                                              double.parse(cartList[index]
                                                      .price_total
                                                      .toString())
                                                  .toStringAsFixed(2),
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            TextButton(
                                                onPressed: () {
                                                  _updateCart(index, "-");
                                                },
                                                child: const Text("-")),
                                            Text(cartList[index]
                                                .cartqty
                                                .toString()),
                                            TextButton(
                                                onPressed: () {
                                                  _updateCart(index, "+");
                                                },
                                                child: const Text("+")),
                                            IconButton(
                                                onPressed: () {
                                                   _deleteDialog(index);
                                                },
                                                icon: const Icon(Icons.delete))
                                          ],
                                        )
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
                                  productQuantity,
                                  style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Total: RM " +
                                      totalpayable.toStringAsFixed(2),
                                  style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            ElevatedButton(
                                onPressed: _checkOutDialog,
                                child: const Text("Check Out",
                                style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),)
                                )
                          ],
                        ),
                      ),
                    )
                  ],
                )));
  }

  void _loadCart() {
    http.post(
        Uri.parse(CONSTANTS.server + "/fyp/php/load_cart.php"),
        body: {
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
        if (extractdata['cart'] != null) {
          cartList = <Cart>[];
          extractdata['cart'].forEach((v) {
            cartList.add(Cart.fromJson(v));
          });
          int qty = 0;
          totalpayable = 0.00;
          for (var element in cartList) {
            qty = qty + int.parse(element.cartqty.toString());
            totalpayable =
                totalpayable + double.parse(element.price_total.toString());
          }
          productQuantity = qty.toString() + " products in your cart";
          setState(() {});
        }
      } else {
        titlecenter = "Your Cart is Empty 😞 ";
        cartList.clear();
        setState(() {});
      }
    });
  }

  void _checkOutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Check Out",
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => PaymentScreen(
                            user: widget.user,
                            totalpayable: totalpayable,
                            )));
                _loadCart();
              },
            ),
            TextButton(
              child: const Text(
                "No",
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteItem(int index) {
    http.post(
        Uri.parse(CONSTANTS.server + "/fyp/php/delete_cart.php"),
        body: {
          'email': widget.user.email,
          'cartid': cartList[index].cartid
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        _loadCart();
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }

  void _updateCart(int index, String s) {
    if (s == "-") {
      if (int.parse(cartList[index].cartqty.toString()) == 1) {
        _deleteItem(index);
      }
    }
    http.post(
        Uri.parse(CONSTANTS.server + "/fyp/php/update_cart.php"),
        body: {
          'cartid': cartList[index].cartid, 
          'prid': cartList[index].prid, 
          'operation': s}).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        _loadCart();
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }
  
    void _deleteDialog(int index) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Delete Product From Cart?",
              style: TextStyle(),
            ),
            content: const Text("Are you sure?", style: TextStyle()),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "Yes",
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  _deleteItem(index);
                },
              ),
              TextButton(
                child: const Text(
                  "No",
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
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
}