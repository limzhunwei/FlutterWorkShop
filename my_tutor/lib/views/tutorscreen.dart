import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/constant.dart';
import '../models/tutor.dart';


class TutorScreen extends StatefulWidget {
  const TutorScreen({Key? key}) : super(key: key);

  @override
  State<TutorScreen> createState() => _TutorScreenState();
}

class _TutorScreenState extends State<TutorScreen> {
  List <Tutor> tutorList = <Tutor>[];
  String search = "";
   String titlecenter = "Loading...";
   late double screenHeight, screenWidth, resWidth;
  var numofpage, curpage = 1;
  var color;
  late String _title;
  
 @override
  void initState() {
    super.initState();
    _loadTutors(1, search);
    _title = 'Tutor Page';
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
            body: tutorList.isEmpty
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
                      children: List.generate(tutorList.length, (index) {
                        return InkWell(
                          splashColor: Colors.amber,
                          onTap: () => {_loadTutorDetails(index)},
                          child: Card(
                              child: Column(
                            children: [
                              Flexible(
                                flex: 6,
                                child: CachedNetworkImage(
                                  imageUrl: CONSTANT.server +
                                      "/my_tutor/mobile/assets/tutors/" +
                                      tutorList[index].tutor_id.toString() +
                                      '.jpg',
                                  width: resWidth,
                                  placeholder: (context, url) =>
                                      const LinearProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              const SizedBox(height: 18),
                              Flexible(
                                  flex: 4,
                                  child: Column(
                                    children: [
                                      Text(
                                        tutorList[index].tutor_id.toString()
                                        ),
                                      Text(
                                        tutorList[index].tutor_name.toString(),
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                            ),
                                      Text(
                                        tutorList[index].tutor_email.toString()
                                        ),
                                      Text(
                                        tutorList[index].tutor_phone.toString()
                                        ),
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
                          onPressed: () => {_loadTutors(index + 1, "")},
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
  
  void _loadTutors(int pageno, String _search) {
    curpage = pageno;
    numofpage ?? 1;
    http.post(
        Uri.parse(CONSTANT.server + "/my_tutor/mobile/php/load_tutors.php"),
        body: {
          'pageno': pageno.toString(),
          'search': _search,
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

        if (extractdata['tutors'] != null) {
          tutorList = <Tutor>[];
          extractdata['tutors'].forEach((v) {
            tutorList.add(Tutor.fromJson(v));
          });
        } else {
          titlecenter = "No Tutor Available";
        }
        setState(() {});
      }
    });
  }

    _loadTutorDetails(int index) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Tutor's Profile",
              style: TextStyle(),
            ),
            content: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CachedNetworkImage(
                  imageUrl: CONSTANT.server +
                      "/my_tutor/mobile/assets/tutors/" +
                      tutorList[index].tutor_id.toString() +
                      '.jpg',
                  width: resWidth,
                  placeholder: (context, url) =>
                      const LinearProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                const SizedBox(height: 10,),
                Text(
                  tutorList[index].tutor_name.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center
                    ),
                const SizedBox(height: 10,),
                  Row(
                    children: [
                      const Icon(
                         Icons.person),
                      const SizedBox(width: 5),
                      Text(
                        tutorList[index].tutor_id.toString()
                        ),
                    ],
                  ),
                const SizedBox(height: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.description),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            tutorList[index].tutor_description.toString(),),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                      Row(
                        children: [
                          const Icon(
                            Icons.email),
                          const SizedBox(width: 5),
                          Text(
                            tutorList[index].tutor_email.toString(),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        children: [
                          const Icon(
                            Icons.phone_android),
                          const SizedBox(width: 5),
                          Text(
                            tutorList[index].tutor_phone.toString(),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        children: [
                          const Icon(
                            Icons.date_range),
                          const SizedBox(width: 5),
                          Text(
                            tutorList[index].tutor_datereg.toString()
                            ),
                        ],
                      ),
                    ])
              ],
            )),
            actions: [
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
}