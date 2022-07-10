import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/subject.dart';
import 'package:http/http.dart' as http;
import '../models/constant.dart';
import '../models/user.dart';
import 'cartscreen.dart';


class SubjectScreen extends StatefulWidget {
  final User user;
  const SubjectScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  List <Subject> subjectList = <Subject>[];
  String search = "";
   String titlecenter = "Loading...";
   late double screenHeight, screenWidth, resWidth;
  var numofpage, curpage = 1;
  var color;
  TextEditingController _searchController = TextEditingController();
  String dropdownvalue = 'All';
  var rating = [
    'All',
    '5',
    '4',
    '3',
    '2',
    '1',
  ];
  
 @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    _loadSubjects(1, search, dropdownvalue);
    });
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
        title: const Text("Subjects",),
         actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _loadSearchDialog();
            },
          ),
          TextButton.icon(
            onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => CartScreen(
                              user: widget.user,
                            )));
                _loadSubjects(1, search, "All");
                _loadMyCart();
            },
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            label: const Text("Cart",
                style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
            body: subjectList.isEmpty
          ? Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Column(
                children: [
                  Center(
                      child: Text(titlecenter,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                ],
              ),
            )
          : Column(children: [
              Expanded(
                  child: GridView.count(
                      crossAxisCount: 1,
                      childAspectRatio: (1 / 1),
                      children: List.generate(subjectList.length, (index) {
                        return InkWell(
                          splashColor: Colors.blue,
                          onTap: () => {_loadSubjectDetails(index)},
                          child: Card(
                            color: Colors.blue[50],
                              child: Column(
                            children: [
                              Flexible(
                                flex: 5,
                                child: CachedNetworkImage(
                                  imageUrl: CONSTANTS.server +
                                  "/my_tutor/mobile/assets/courses/" +
                                  subjectList[index].subject_id.toString() +
                                  '.JPG',
                                  width: resWidth,
                                  placeholder: (context, url) =>
                                      const LinearProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Flexible(
                                  flex: 5,
                                  child: Column(
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            subjectList[index].subject_name.toString(),
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                                textAlign: TextAlign.center
                                                ),
                                          Text(
                                            "RM " +
                                            double.parse(subjectList[index].subject_price.toString()).toStringAsFixed(2),
                                            style: const TextStyle(
                                                fontSize: 16,),
                                                ),
                                          Text(
                                            subjectList[index].subject_sessions.toString() +
                                            " sessions",
                                            style: const TextStyle(
                                                fontSize: 16,),
                                              ),
                                          Text(
                                            "Rating: " + subjectList[index].subject_rating.toString(),
                                            style: const TextStyle(
                                                fontSize: 16,),
                                              ),
                                        ],
                                      ),
                                       IconButton(
                                           onPressed: () {
                                             _addDialog(index);
                                           },
                                           icon: const Icon(
                                               Icons.shopping_cart)),
                                    ], 
                                  ))
                            ],
                          )),
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
                          onPressed: () => {_loadSubjects(index + 1, "", dropdownvalue)},
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(color: color),
                          )),
                    );
                  },
                ),
              ),
            ]),
    );
  }
  
  void _loadSubjects(int pageno, String _search, String _rating) async {
    curpage = pageno;
    numofpage ?? 1;
    http.post(
        Uri.parse(CONSTANTS.server + "/my_tutor/mobile/php/load_subjects.php"),
        body: {
          'pageno': pageno.toString(),
          'search': _search,
          'rating': _rating,
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        numofpage = int.parse(jsondata['numofpage']);

        if (extractdata['subjects'] != null) {
          subjectList = <Subject>[];
          extractdata['subjects'].forEach((v) {
            subjectList.add(Subject.fromJson(v));
          });
        } else {
          titlecenter = "No Subject Available";
          subjectList.clear();
        }
        setState(() {});
      }else {
        //do something
        titlecenter = "No Subject Available";
        subjectList.clear();
        setState(() {});
      }
    });
  }

    _loadSubjectDetails(int index) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Subject Details",
              style: TextStyle(),
            ),
            content: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CachedNetworkImage(
                  imageUrl: CONSTANTS.server +
                  "/my_tutor/mobile/assets/courses/" +
                  subjectList[index].subject_id.toString() +
                  '.JPG',
                  fit: BoxFit.cover,
                  width: resWidth,
                  placeholder: (context, url) =>
                      const LinearProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                const SizedBox(height: 10,),
                Text(
                  subjectList[index].subject_name.toString(),
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
                        subjectList[index].subject_description.toString(),
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
                      Text(
                        "RM " +
                        double.parse(subjectList[index].subject_price.toString()).toStringAsFixed(2)
                        ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      const Icon(
                         Icons.person),
                      const SizedBox(width: 5),
                      Text(
                        subjectList[index].tutor_id.toString()
                        ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      const Icon(
                         Icons.av_timer),
                      const SizedBox(width: 5),
                      Text(
                        subjectList[index].subject_sessions.toString() +
                        " sessions"
                        ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      const Icon(
                         Icons.star_rate),
                      const SizedBox(width: 5),
                      Text(
                        subjectList[index].subject_rating.toString()
                        ),
                    ],
                  ),
                ])
              ],
            )),
            actions: [
              SizedBox(
                  width: screenWidth / 1,
                  child: ElevatedButton(
                      onPressed: () {
                       _addDialog(index);
                      },
                      child: const Text("Add to cart"))),
              TextButton(
                child: const Text(
                  "Close",
                  style: TextStyle(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
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
                            labelText: 'Search Subejct',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        height: 60,
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5.0))),
                        child: DropdownButton(
                          value: dropdownvalue,
                          underline: const SizedBox(),
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: rating.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownvalue = newValue!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      search = _searchController.text;
                      Navigator.of(context).pop();
                      _loadSubjects(1, search, dropdownvalue);
                    },
                    child: const Text("Search"),
                  )
                ],
              );
            },
          );
        });
  }

   void _loadMyCart() {
      http.post(
          Uri.parse(
              CONSTANTS.server + "/my_tutor/mobile/php/load_mycartqty.php"),
          body: {
            "email": widget.user.email.toString(),
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
        }
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
              "Add Subject to Cart?",
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
        Uri.parse(CONSTANTS.server + "/my_tutor/mobile/php/insert_cart.php"),
        body: {
          "email": widget.user.email.toString(),
          "subject_id": subjectList[index].subject_id.toString(),
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
  
}