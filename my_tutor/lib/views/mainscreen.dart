import 'package:flutter/material.dart';
import 'package:my_tutor/models/user.dart';

import '../models/subject.dart';
import 'subjectscreen.dart';
import 'tutorscreen.dart';


class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({Key? key, required this.user, }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late final Color? backgroundColor;
  List<Subject> subjectList = <Subject>[];
  late double screenHeight, screenWidth, resWidth;
  String titlecenter = "Loading...";
  String appbarTitle = "Subject";
  var appBarTitleText = new Text("Subject");

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBarTitleText,
      ),
      body: Center( child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_stories),
            label: 'Subject',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Tutors',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.subscriptions),
            label: 'Subscribe',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favourite',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: Colors.black,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightBlue,
        onTap: _onItemTapped,
      ),
    );
  }

  static const List<Widget> _widgetOptions = <Widget>[
    SubjectScreen(),
    TutorScreen(),

    Text(
      'Subscribe Page',
    ),
    Text(
      'Favourite Page',
    ),
    Text(
      'Profile Page',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if(index == 0){
        appbarTitle = "Subject";
        appBarTitleText = new Text(appbarTitle);
      }
      else if(index == 1){
        appbarTitle = "Tutors";
        appBarTitleText = new Text(appbarTitle);
      }
      else if(index == 2){
        appbarTitle = "Subscribe";
        appBarTitleText = new Text(appbarTitle);
      }
      else if(index == 3){
        appbarTitle = "Favourite";
        appBarTitleText = new Text(appbarTitle);
      }
      else if(index == 4){
        appbarTitle = "Profile";
        appBarTitleText = new Text(appbarTitle);
      }
    });
  }
  

}