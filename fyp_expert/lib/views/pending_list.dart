import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp_expert/views/login_screen.dart';
import 'package:fyp_expert/views/seller_details.dart';

import 'package:intl/intl.dart';

import '../models/seller.dart';
import '../models/constant.dart';
import 'package:http/http.dart' as http;


class PendingList extends StatefulWidget {
  const PendingList({super.key});

  @override
  State<PendingList> createState() => _PendingListState();
}

class _PendingListState extends State<PendingList> {
  List<Seller> sellerList = <Seller>[];
  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  final df = DateFormat('dd/MM/yyyy hh:mm a');
  var numofpage, curpage = 1, color;

  @override
  void initState() {
    super.initState();
    _loadSellers(1);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
      //rowcount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      //rowcount = 3;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Herbs Repository'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () {
              _signOut();
            },
          ),
        ],
      ),
      body: sellerList.isEmpty
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
                    child: Text("Pending List",
                        style: TextStyle(
                            fontSize: 20, 
                            fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                        child: GridView.count(
                            crossAxisCount: 1,
                            childAspectRatio: (1 / 0.41),
                            children: List.generate(sellerList.length, (index) {
                              return Card(
                                elevation: 5,
                                child: InkWell(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 255, 194, 220),
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
                                                0: FlexColumnWidth(4),
                                                1: FlexColumnWidth(6),
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
                                                      "Seller ID",
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
                                                      sellerList[index]
                                                          .seller_id
                                                          .toString(),
                                                      style: const TextStyle(fontSize: 15),
                                                    ),
                                                  ),
                                                )
                                              ]),
                                                TableRow(children: [
                                                  const TableCell(
                                                    child: Text(
                                                      "Seller Name",
                                                      style: TextStyle(
                                                        fontSize: 15, 
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 10.0),
                                                      child: Text(
                                                        sellerList[index]
                                                        .seller_name
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
                                                      "Phone Number",
                                                      style: TextStyle(
                                                        fontSize: 15, 
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 10.0),
                                                      child: Text(
                                                        sellerList[index]
                                                          .seller_phone
                                                          .toString(),
                                                        style: TextStyle(
                                                            fontSize: 15,),
                                                      ),
                                                    ),
                                                  )
                                                ]),
                                                TableRow(children: [
                                                  const TableCell(
                                                    child: Text(
                                                      "Register Date",
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
                                                        sellerList[index]
                                                            .register_date
                                                            .toString())),
                                                        style: const TextStyle(
                                                          fontSize: 15),
                                                      ),
                                                    ),
                                                  )
                                                ]),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            Align(
                                            alignment: Alignment.bottomRight,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                elevation: 5,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(20.0)),
                                                  minimumSize: const Size(20, 30),),
                                              child: const Text("View Details",
                                              style: TextStyle(fontSize: 20),),
                                              onPressed: (){
                                                _sellerDetails(sellerList[index].seller_id.toString());
                                              }
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
                                          _loadSellers(index + 1)
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

  void _loadSellers(int pageno) {
    curpage = pageno;
    numofpage ?? 1;
    http.post(
        Uri.parse(CONSTANTS.server + "/fyp/php/load_pendingList.php"),
        body: {
          'pageno': pageno.toString(),
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
      if (extractdata['seller'] != null) {
        numofpage = int.parse(data['numofpage']);
        sellerList = <Seller>[];
        extractdata['seller'].forEach((v) {
          sellerList.add(Seller.fromJson(v));
        });
      }} else {
        titlecenter = "No New Application";
      }
      setState(() {});
    });
  }

  _sellerDetails(String seller_id) {
    http.post(
      Uri.parse(CONSTANTS.server + "/fyp/php/load_seller_details.php"),
      body: {
        "seller_id": seller_id
        }).then((response) async {
          var data = jsonDecode(response.body);
          if (response.statusCode == 200 && data['status'] == 'success') {
            Seller seller = Seller.fromJson(data['data']);
            await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (content) => Seller_Details_Screen(
                    seller: seller,
                      )));
            _loadSellers(1);
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
        context, MaterialPageRoute(builder: (context) => const LoginScreen())
      );
  }
}