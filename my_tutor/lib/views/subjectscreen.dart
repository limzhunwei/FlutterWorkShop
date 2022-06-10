import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/subject.dart';
import 'package:http/http.dart' as http;
import '../models/constant.dart';


class SubjectScreen extends StatefulWidget {
  const SubjectScreen({Key? key}) : super(key: key);

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
  
 @override
  void initState() {
    super.initState();
    _loadSubjects(1, search);
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
                          splashColor: Colors.amber,
                          onTap: () => {_loadSubjectDetails(index)},
                          child: Card(
                              child: Column(
                            children: [
                              Flexible(
                                flex: 6,
                                child: CachedNetworkImage(
                                  imageUrl: CONSTANT.server +
                                  "/my_tutor/mobile/assets/courses/" +
                                  subjectList[index].subject_id.toString() +
                                  '.jpg',
                                  width: resWidth,
                                  placeholder: (context, url) =>
                                      const LinearProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Flexible(
                                  flex: 4,
                                  child: Column(
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
                                        double.parse(subjectList[index].subject_price.toString()).toStringAsFixed(2)
                                        ),
                                      Text(
                                        subjectList[index].subject_sessions.toString() +
                                        " sessions"
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
                          onPressed: () => {_loadSubjects(index + 1, "")},
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
  
  void _loadSubjects(int pageno, String _search) {
    curpage = pageno;
    numofpage ?? 1;
    http.post(
        Uri.parse(CONSTANT.server + "/my_tutor/mobile/php/load_subjects.php"),
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

        if (extractdata['subjects'] != null) {
          subjectList = <Subject>[];
          extractdata['subjects'].forEach((v) {
            subjectList.add(Subject.fromJson(v));
          });
        } else {
          titlecenter = "No Subject Available";
        }
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
                  imageUrl: CONSTANT.server +
                  "/my_tutor/mobile/assets/courses/" +
                  subjectList[index].subject_id.toString() +
                  '.jpg',
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