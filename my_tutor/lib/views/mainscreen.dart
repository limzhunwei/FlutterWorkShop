import 'package:flutter/material.dart';
import 'package:my_tutor/models/user.dart';

import '../models/subject.dart';
import '../models/user.dart';
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
  TextEditingController searchController = TextEditingController();
  String search = "";
  late List<Widget> _widgetOptions;

  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
    SubjectScreen(user: widget.user,),
    const TutorScreen(),
    const Text(
      'Subscribe Page',
    ),
    const Text(
      'Favourite Page',
    ),
    const Text(
      'Profile Page',
    ),
  ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_stories),
            label: 'Subjects',
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
        selectedItemColor: const Color.fromRGBO(3, 169, 244, 1),
        onTap: _onItemTapped,
      ),
    );
  }

}