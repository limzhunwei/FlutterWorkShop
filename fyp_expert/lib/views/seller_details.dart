import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import '../models/constant.dart';
import '../models/seller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;


class Seller_Details_Screen extends StatefulWidget {
  final Seller seller;
  const Seller_Details_Screen({Key? key, required this.seller}) : super(key: key);

  @override
  State<Seller_Details_Screen> createState() => _Seller_Details_ScreenState();
}

class _Seller_Details_ScreenState extends State<Seller_Details_Screen> {
  late double screenHeight, screenWidth, resWidth;
  File? _image;
  final _formKey = GlobalKey<FormState>();
  final focus = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final focus4 = FocusNode();
  bool editForm = false;

  final TextEditingController _sellernameEditingController = TextEditingController();
  final TextEditingController _sellerphoneEditingController = TextEditingController();
  final TextEditingController _selleraddressEditingController = TextEditingController();
  final TextEditingController _selleremailEditingController = TextEditingController();
  final TextEditingController _sellerstatusEditingController = TextEditingController();
  
  @override
  void initState(){
    super.initState();
    _sellernameEditingController.text = widget.seller.seller_name.toString();
    _sellerphoneEditingController.text = widget.seller.seller_phone.toString();
    _selleraddressEditingController.text = widget.seller.seller_address.toString();
    _selleremailEditingController.text = widget.seller.seller_email.toString();
    _sellerstatusEditingController.text = widget.seller.seller_status.toString();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if(screenWidth <= 600){
      resWidth = screenWidth;
    }else{
      resWidth = screenWidth * 0.75;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seller Details'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: resWidth,
            child: Column(
              children: [
                SizedBox(
                  height: screenHeight / 2.5,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: Card(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: _image == null
                            ? NetworkImage(
                              CONSTANTS.server + "/fyp/assets/documentation/" + widget.seller.seller_id.toString() + ".jpg")
                            : FileImage(_image!) as ImageProvider,
                            fit: BoxFit.fill,
                          ),
                      )),
                      ),
                      )),
                Card(
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 5,),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            enabled: editForm,
                            onFieldSubmitted: (v){
                              FocusScope.of(context).requestFocus(focus);
                            },
                            controller: _sellernameEditingController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              labelText: 'Seller Name',
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.person),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              )
                            ),
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            enabled: editForm,
                            focusNode: focus,
                            onFieldSubmitted: (v){
                              FocusScope.of(context).requestFocus(focus1);
                            },
                            maxLines: 4,
                            controller: _selleraddressEditingController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              labelText: 'Seller Address',
                              alignLabelWithHint: true,
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.house_rounded),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),))),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            enabled: editForm,
                            focusNode: focus1,
                            onFieldSubmitted: (v){
                              FocusScope.of(context).requestFocus(focus2);},
                            controller: _sellerphoneEditingController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Seller Phone Number',
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.phone_android_rounded),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),))),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            enabled: editForm,
                            focusNode: focus2,
                            onFieldSubmitted: (v){
                              FocusScope.of(context).requestFocus(focus3);},
                            controller: _sellerstatusEditingController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Seller Status',
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.approval_rounded),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),))),
                          const SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  fixedSize: 
                                  Size(resWidth / 3, resWidth * 0.1)),
                                onPressed: widget.seller.seller_status.toString().contains('Rejected') || widget.seller.seller_status == null
                                ? () {
                                  _approveDialog();
                                  } : null,
                                child: const Text('Approve'),
                              ),
                              const SizedBox(width: 20,),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  fixedSize: 
                                  Size(resWidth / 3, resWidth * 0.1)),
                                onPressed: widget.seller.seller_status.toString().contains('Approved') || widget.seller.seller_status == null
                                ? () {
                                  _rejectDialog();
                                  } : null,
                                child: const Text('Reject'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15,),
                        ],
                      ))
                    )
                )
              ]
              ))))
    );
  }

  void _approveDialog() {
    showDialog(
      context: context, 
      builder: (BuildContext context){
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Approve This Seller?",
              style: TextStyle(),
            ),
            content: const Text("Are you sure?", style: TextStyle()),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "Yes",
                  style: TextStyle(),
                  ),
                  onPressed: (){
                    Navigator.of(context).pop();
                    _approveOrReject("Approve");
                  },
              ),
              TextButton(
                child: const Text(
                  "No",
                  style: TextStyle(),
                  ),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
              ),
            ],
        );
      },
    );
  }

  void _rejectDialog() {
    showDialog(
      context: context, 
      builder: (BuildContext context){
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Reject This Seller?",
              style: TextStyle(),
            ),
            content: const Text("Are you sure?", style: TextStyle()),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "Yes",
                  style: TextStyle(),
                  ),
                  onPressed: (){
                    Navigator.of(context).pop();
                    _approveOrReject("Reject");
                  },
              ),
              TextButton(
                child: const Text(
                  "No",
                  style: TextStyle(),
                  ),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
              ),
            ],
        );
      },
    );
  }
  
  void _approveOrReject(String aor) {
    http.post(
        Uri.parse(CONSTANTS.server + "/fyp/php/update_seller_status.php"),
        body: {
          'seller_id': widget.seller.seller_id,
          'seller_email': widget.seller.seller_email,
          'aor': aor
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Successed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
            Navigator.of(context).pop();
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
            Navigator.of(context).pop();
      }
    });
  }
  
}
