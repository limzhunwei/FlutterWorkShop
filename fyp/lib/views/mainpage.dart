import 'package:flutter/material.dart';
import 'package:fyp/views/cart_screen.dart';
import 'package:fyp/views/order_screen.dart';
import 'package:fyp/views/productscreen.dart';

import '../models/user.dart';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({Key? key, required this.user}) : super(key: key);

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
    ProductScreen(user: widget.user,),
    CartScreen(user: widget.user,),
    OrderScreen(user: widget.user),
    // const Text(
    //   'Profile Page',
    // ),
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
            icon: Icon(Icons.spa_rounded),
            label: 'Product',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_rounded),
            label: 'Cart',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_rounded),
            label: 'Order',
            backgroundColor: Colors.black,
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.person),
          //   label: 'Profile',
          //   backgroundColor: Colors.black,
          // ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromRGBO(3, 169, 244, 1),
        onTap: _onItemTapped,
      ),
    );
  }

}