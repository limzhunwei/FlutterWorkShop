import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp/models/product.dart';
import 'package:fyp/models/user.dart';
import 'package:fyp/views/loginscreen.dart';
import 'package:intl/intl.dart';

import '../models/constant.dart';
import 'package:http/http.dart' as http;

class ProductScreen extends StatefulWidget {
  final User user;
  const ProductScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List productlist = [];
  String titlecenter = "Loading data...";
  late double screenHeight, screenWidth, resWidth;
  final df = DateFormat('dd/MM/yyy hh:mm a');
  late ScrollController _scrollController;
  int scrollcount = 10;
  int rowcount = 2;
  int numprd = 0;
  var numofpage, curpage = 1, color;
  String search = "";
  TextEditingController _searchController = TextEditingController();


   @override
  void initState() {
    super.initState();
    _loadBuyerProduct(1, search);
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if(screenWidth<=600){
      resWidth = screenWidth;
    }else{
      resWidth = screenWidth * 0.75;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _loadSearchDialog();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () {
              _signOut();
            },
          ),
        ],
      ),
      body: productlist.isEmpty
      ? Center(
        child: Text(titlecenter,
                style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold)))
      : Column(children: [
          const Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Text("Available Product",
          style: TextStyle(
            fontSize: 22, fontWeight: FontWeight.bold)),),
          Expanded(
            child: GestureDetector(
              child: GridView.count(
                crossAxisCount: 2,
                controller: _scrollController,
                children: List.generate(productlist.length, (index){
                  return InkWell(
                    splashColor: Colors.blue,
                    onTap: () => {_loadProductDetails(index)},
                    child: Card(
                      child: Column(
                        children: [
                          Flexible(
                            flex: 6,
                            child: CachedNetworkImage(
                              width: screenWidth,
                              fit: BoxFit.cover,
                              imageUrl: CONSTANTS.server + "/fyp/assets/products/" + productlist[index]['prid'] + ".jpg",
                              placeholder: (context, url) => const LinearProgressIndicator(),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                          ),
                          Flexible(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children:[
                                  Text(
                                    productlist[index]['prname'].toString(),
                                    style: TextStyle(fontSize:resWidth * 0.04, fontWeight: FontWeight.bold)),
                                  Text("RM" 
                                  + double.parse(productlist[index]['prprice']).toStringAsFixed(2) 
                                  + " - " 
                                  + productlist[index]['prqty'] + " in stock"),
                                ],
                              ),
                            )),
                        ],
                      )),
                  );
                }),
              ),
            ),
            ),
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
                        onPressed: () => {_loadBuyerProduct(index + 1, "")},
                        child: Text(
                          (index + 1).toString(),
                          style: TextStyle(color: color),
                          )),
                    );
                },
                ),
              ),
        ], 
      ),
      );
  }

  void _loadBuyerProduct(int pageno, String _search) async{
    curpage = pageno;
    numofpage ?? 1;
    http.post(Uri.parse(CONSTANTS.server + "/fyp/php/loadbuyer_product.php"),
    body: {
      'pageno': pageno.toString(),
      'search': _search,
    }).then((response){
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success'){
        var extractdata = data['data'];
        numofpage = int.parse(data['numofpage']);
        setState((){
          productlist = extractdata["products"];
          numprd = productlist.length;
          if(scrollcount >= productlist.length){
            scrollcount = productlist.length;
          }
        });
      } else{
        setState((){
          titlecenter = "No Data";
        });
       }
    });
   }

   String truncateString(String str){
    if (str.length > 15){
      str = str.substring(0, 15);
      return str + "...";
    }else{
      return str;
    }
   }

   _scrollListener(){
    if(_scrollController.offset >=
      _scrollController.position.maxScrollExtent &&
      !_scrollController.position.outOfRange){
        setState((){
          if(productlist.length > scrollcount){
            scrollcount = scrollcount + 10;
            if(scrollcount >= productlist.length){
              scrollcount = productlist.length;
            }
          }
        });
      }
   }
   
    _signOut() async {
      Fluttertoast.showToast(
              msg: "Sign Out Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);

      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
  
  _loadProductDetails(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            titlePadding: EdgeInsets.zero,
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
              const Text('Product Details'),
              ],
            ),
            content: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CachedNetworkImage(
                  imageUrl: CONSTANTS.server +
                  "/fyp/assets/products/" +
                  productlist[index]['prid'] + ".jpg",
                  fit: BoxFit.cover,
                  width: resWidth,
                  placeholder: (context, url) =>
                      const LinearProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                const SizedBox(height: 10,),     
                Text(
                  productlist[index]['prname'].toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,),
                    textAlign: TextAlign.center
                    ),
                const SizedBox(height: 10,),                
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(
                    children: [
                      const Icon(
                         Icons.description),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                        productlist[index]['prdesc'].toString(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      const Icon(
                         Icons.attach_money),
                      const SizedBox(width: 5),
                      Text("RM" + double.parse(productlist[index]['prprice']).toStringAsFixed(2) 
                        ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      const Icon(
                         Icons.numbers_rounded),
                      const SizedBox(width: 5),
                      Text(productlist[index]['prqty'] + " in stock"
                        ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      const Icon(
                         Icons.person),
                      const SizedBox(width: 5),
                      Text("Sold by: " + productlist[index]['seller_name'].toString(),
                      ),
                    ],
                  ),
                ]),
                IconButton(
                  onPressed: () {
                    _addDialog(index);
                    },
                    icon: const Icon(
                      Icons.shopping_cart)),
              ],
            )),
          );
        });
  }
  
  void _addDialog(int index) {
          showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Add Product to Cart?",
            ),
            content: const Text("Are you sure?", style: TextStyle()),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "Yes",
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  _addtoCart(index);
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
  
  void _addtoCart(int index) {
        http.post(
        Uri.parse(CONSTANTS.server + "/fyp/php/insert_cart.php"),
        body: {
          "email": widget.user.email.toString(),
          "prid": productlist[index]['prid'].toString(),
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        print(jsondata['data']['carttotal'].toString());
        setState(() {
          widget.user.cart = jsondata['data']['carttotal'].toString();
        });
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }
  
  void _loadSearchDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, StateSetter setState) {
              return AlertDialog(
                title: const Text(
                  "Search",
                ),
                content: SizedBox(
                  // height: screenHeight / 3,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                            labelText: 'Search Products',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ),
                      const SizedBox(height: 5),
                      // Container(
                      //   height: 60,
                      //   padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      //   decoration: BoxDecoration(
                      //       border: Border.all(color: Colors.grey),
                      //       borderRadius:
                      //           const BorderRadius.all(Radius.circular(5.0))),
                      //   child: DropdownButton(
                      //     value: dropdownvalue,
                      //     underline: const SizedBox(),
                      //     isExpanded: true,
                      //     icon: const Icon(Icons.keyboard_arrow_down),
                      //     items: rating.map((String items) {
                      //       return DropdownMenuItem(
                      //         value: items,
                      //         child: Text(items),
                      //       );
                      //     }).toList(),
                      //     onChanged: (String? newValue) {
                      //       setState(() {
                      //         dropdownvalue = newValue!;
                      //       });
                      //     },
                      //   ),
                      // ),
                    ],
                  ),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          search = _searchController.text;
                          Navigator.of(context).pop();
                          _loadBuyerProduct(1, search);
                        },
                        child: const Text("Search"),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          search = "";
                          Navigator.of(context).pop();
                          _loadBuyerProduct(1, search);
                        },
                        child: const Text("Display All"),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        });
  }

}


   
