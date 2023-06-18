import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fyp_seller/views/productscreen.dart';

import '../models/constant.dart';
import '../models/product.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../models/seller.dart';

class NewProductPage extends StatefulWidget {
  final Seller seller;
  const NewProductPage({Key? key, required this.seller}) : super(key: key);

  @override
  State<NewProductPage> createState() => _NewProductPageState();
}

class _NewProductPageState extends State<NewProductPage> {
  late double screenHeight, screenWidth, resWidth;
  File? _image;
  var pathAsset = "assets/images/camera.png";
  final _formKey = GlobalKey<FormState>();
  final focus = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final focus4 = FocusNode();

  final TextEditingController _prnameEditingController = TextEditingController();
  final TextEditingController _prdescEditingController = TextEditingController();
  final TextEditingController _prpriceEditingController = TextEditingController();
  final TextEditingController _prqtyEditingController = TextEditingController();
  
  @override
  void initState(){
    super.initState();
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
        title: const Text('New Product'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: resWidth,
            child: Column(
              children: [
                SizedBox(
                  height: screenHeight / 2.5,
                  child: GestureDetector(
                    onTap: _selectImage,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                          child: Card(
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: _image == null
                                  ? AssetImage(pathAsset)
                                  : FileImage(_image!) as ImageProvider,
                                  fit: BoxFit.fill,
                                ),
                            )),
                            ),
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
                            validator: (val) => val!.isEmpty || (val.length<3)
                            ? "Product name must be longer than 3"
                            : null,
                            onFieldSubmitted: (v){
                              FocusScope.of(context).requestFocus(focus);
                            },
                            controller: _prnameEditingController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              labelText: 'Product Name',
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.spa_rounded),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              )
                            ),
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            validator: (val) => val!.isEmpty || (val.length<10)
                            ? "Product description must be longer than 10"
                            : null,
                            focusNode: focus,
                            onFieldSubmitted: (v){
                              FocusScope.of(context).requestFocus(focus1);
                            },
                            maxLines: 4,
                            controller: _prdescEditingController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              labelText: 'Product Description',
                              alignLabelWithHint: true,
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.description),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),))),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            validator: (val) => val!.isEmpty
                            ? "Product price must contain value"
                            : null,
                            focusNode: focus1,
                            onFieldSubmitted: (v){
                              FocusScope.of(context).requestFocus(focus2);},
                            controller: _prpriceEditingController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Product Price',
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.money),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),))),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            validator: (val) => val!.isEmpty
                            ? "Quantity should be more than 0"
                            : null,
                            focusNode: focus2,
                            onFieldSubmitted: (v){
                              FocusScope.of(context).requestFocus(focus3);},
                            controller: _prqtyEditingController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Product Quantity',
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.ad_units),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),))),
                          const SizedBox(height: 15,),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(screenWidth, screenHeight/13)),
                              child: const Text('Add Product'),
                              onPressed: ()=>{
                                _newProductDialog(),
                              },
                          ),
                        ],
                      ))
                    )
                )
              ]
              ))))
    );
  }

  void _selectImage() {
    showDialog(
      context: context, 
      builder: (BuildContext context){
        return AlertDialog(
          title: const Text(
            "Select From",
            style: TextStyle(),
          ),
          content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                    onPressed: () => {
                          Navigator.of(context).pop(), 
                          _galleryPicker(),
                        },
                    icon: const Icon(Icons.browse_gallery),
                    label: const Text("Gallery")),
                TextButton.icon(
                    onPressed: () =>
                        {Navigator.of(context).pop(), 
                        _cameraPicker()},
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Camera")),
              ],
            ));
        },
      );
  }

    void _galleryPicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _cropImage();
    }
  }

  void _cameraPicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _cropImage();
    }
  }

    Future<void> _cropImage() async {
    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: _image!.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.lightBlue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {});
    }
  }
  
  void _newProductDialog() {
        if(!_formKey.currentState!.validate()){
      Fluttertoast.showToast(
        msg: "Please fill in all the required fields",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 14.0);
        return;
    }
    if(_image == null){
      Fluttertoast.showToast(
        msg: "Please insert the product picture",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 14.0);
        return;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Add this product",
              style: TextStyle(),
            ),
            content: const Text("Are you sure?", style: TextStyle()),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "Yes",
                  style: TextStyle(),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  _addNewProduct();
                },
              ),
              TextButton(
                child: const Text(
                  "No",
                  style: TextStyle(),
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
  
  void _addNewProduct() {
        String _prname = _prnameEditingController.text;
    String _prdesc = _prdescEditingController.text;
    String _prprice = _prpriceEditingController.text;
    String _prqty = _prqtyEditingController.text;
    String base64Image = base64Encode(_image!.readAsBytesSync());

    http.post(
        Uri.parse(CONSTANTS.server + "/fyp/php/new_product.php"),
        body: {
          "pridowner": widget.seller.id,
          "prname": _prname,
          "prdesc": _prdesc,
          "prprice": _prprice,
          "prqty": _prqty,
          "image": base64Image,
        }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (content) => ProductScreen(
                        seller: widget.seller
                      )));
            return;
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
            return;
      }
    });
  }

}
