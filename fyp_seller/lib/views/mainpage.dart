import 'package:flutter/material.dart';
import 'package:fyp_seller/models/seller.dart';
import 'package:fyp_seller/views/order_list.dart';
import 'package:fyp_seller/views/productscreen.dart';

class MainScreen extends StatefulWidget {
  final Seller seller;
  const MainScreen({Key? key, required this.seller}) : super(key: key);

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
    ProductScreen(seller: widget.seller,),
    OrderListScreen(seller: widget.seller,)
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
            icon: Icon(Icons.receipt_long_rounded),
            label: 'Order',
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