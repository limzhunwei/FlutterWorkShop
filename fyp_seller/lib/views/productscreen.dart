import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fyp_seller/models/constant.dart';
import 'package:fyp_seller/models/product.dart';
import 'package:fyp_seller/models/seller.dart';
import 'package:fyp_seller/views/loginscreen.dart';
import 'package:fyp_seller/views/new_product.dart';
import 'package:http/http.dart' as http;

import 'product_details.dart';


class ProductScreen extends StatefulWidget {
  final Seller seller;
  const ProductScreen({Key? key, required this.seller}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool _dataChanged = false;
  List productlist = [];
  String titlecenter = "Loading data...";
  late double screenHeight, screenWidth, resWidth;
  late ScrollController _scrollController;
  int scrollcount = 5;
  var numofpage, curpage = 1, color;
  String search = "";
  TextEditingController _searchController = TextEditingController();

  @override
  void initState(){
    super.initState();
    _loadProduct(1, search);
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    Seller seller = widget.seller;
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if(screenWidth<=600){
      resWidth = screenWidth;
    }else{
      resWidth = screenWidth * 0.75;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Seller"),
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
          child: Text("Your Current Product",
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
                    onTap: () => {
                      _loadProductDetails(index)
                    },
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
                                    style: TextStyle(fontSize:resWidth * 0.045, fontWeight: FontWeight.bold)),
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
                        onPressed: () => {_loadProduct(index + 1, "")},
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

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue, 
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>  NewProductPage(seller: seller),
            ));
        }
      ),
    );
    
  }
  
  _loadProductDetails(int index) {
    String _prid = productlist[index]['prid'];
      http.post(
          Uri.parse(CONSTANTS.server + "/fyp/php/load_product_details.php"),
          body: {"prid": _prid}).then((response) async {
          var data = jsonDecode(response.body);
         if (response.statusCode == 200 && data['status'] == 'success') {
          Product product = Product.fromJson(data['data']);
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (content) => Product_Details_Screen(
                        product: product, seller: widget.seller,
                      )));
            _loadProduct(1, search);
        }
      });
  }

    _loadProduct(int pageno, String _search){
      curpage = pageno;
      numofpage ?? 1;
      http.post(
        Uri.parse(CONSTANTS.server + "/fyp/php/loadsellerproduct.php"),
        body: {
          "sellerid": widget.seller.id,
          'pageno': pageno.toString(),
          'search': _search,
        }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        var extractdata = data['data'];
        numofpage = int.parse(data['numofpage']);
        setState((){
          productlist = extractdata["products"];
        });
      } else {
        setState(() {
          titlecenter = "No Data";
        });
      }
    });
  }

  _scrollListener(){
    if(_scrollController.offset >=
      _scrollController.position.maxScrollExtent &&
      !_scrollController.position.outOfRange){
        setState((){
          if(productlist.length > scrollcount){
            scrollcount = scrollcount + 5;
            if(scrollcount >= productlist.length){
              scrollcount = productlist.length;
            }
          }
        });
      }
   }
   
  _signOut() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
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
                          _loadProduct(1, search);
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
                          _loadProduct(1, search);
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