import 'package:flutter/material.dart';
import 'package:fyp_expert/views/pending_list.dart';
import 'package:fyp_expert/views/seller_list.dart';

import '../models/expert.dart';

class MainScreen extends StatefulWidget {
  final Expert expert;
  const MainScreen({Key? key, required this.expert}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late final Color? backgroundColor;
  List productlist = [];
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
    PendingList(),
    SellerList()
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
            icon: Icon(Icons.pending_actions_rounded),
            label: 'Pending',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_rounded),
            label: 'Seller List',
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