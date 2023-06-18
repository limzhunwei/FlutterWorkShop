import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import '../models/constant.dart';
import '../models/product.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../models/seller.dart';


class Product_Details_Screen extends StatefulWidget {
  final Seller seller;
  final Product product;
  const Product_Details_Screen({Key? key, required this.product, required this.seller}) : super(key: key);

  @override
  State<Product_Details_Screen> createState() => _Product_Details_ScreenState();
}

class _Product_Details_ScreenState extends State<Product_Details_Screen> {
  late double screenHeight, screenWidth, resWidth;
  File? _image;
  var pathAsset = "assets/images/camera.png";
  final _formKey = GlobalKey<FormState>();
  final focus = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final focus4 = FocusNode();
  bool editForm = false;

  final TextEditingController _prnameEditingController = TextEditingController();
  final TextEditingController _prdescEditingController = TextEditingController();
  final TextEditingController _prpriceEditingController = TextEditingController();
  final TextEditingController _prqtyEditingController = TextEditingController();
  
  @override
  void initState(){
    super.initState();
    _prnameEditingController.text = widget.product.prname.toString();
    _prdescEditingController.text = widget.product.prdesc.toString();
    _prpriceEditingController.text = widget.product.prprice.toString();
    _prqtyEditingController.text = widget.product.prqty.toString();
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
        title: const Text('Your Product Details'),
        actions: [
          IconButton(onPressed: _onDelete, icon: const Icon(Icons.delete)),
          IconButton(onPressed: _onEdit, icon: const Icon(Icons.edit)),
        ],
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
                                  ? NetworkImage(CONSTANTS.server + "/fyp/assets/products/" + widget.product.prid.toString() + ".jpg")
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
                            enabled: editForm,
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
                            enabled: editForm,
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
                            enabled: editForm,
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
                            enabled: editForm,
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
                          Visibility(
                            visible: editForm,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: 
                                Size(resWidth / 2, resWidth * 0.1)),
                                child: const Text('Update Product'),
                                onPressed: _updateProductDialog,
                            ),
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

  void _onDelete() {
    showDialog(
      context: context, 
      builder: (BuildContext context){
        return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: const Text(
                "Delete this product?", 
                style: TextStyle()
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
                      _deleteProduct();
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

  void _deleteProduct(){
    ProgressDialog progressDialog = ProgressDialog(context,
    message: const Text("Deleting product..."),
    title: const Text("Processing..."));
    progressDialog.show();
    http.post(Uri.parse(CONSTANTS.server + "/fyp/php/delete_product.php"),
      body: {
        "prid": widget.product.prid,
      }).then((response){
        var data = jsonDecode(response.body);
        if(response.statusCode == 200 && data['status'] == 'success'){
          Fluttertoast.showToast(
              msg: "Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
              progressDialog.dismiss();
              Navigator.of(context).pop();;
              return;
          }else{
            Fluttertoast.showToast(
              msg: "Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
              progressDialog.dismiss();
              return;
          }
        });
      }

  void _onEdit() {
    if(!editForm){
      showDialog(
        context: context, 
        builder: (BuildContext context){
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: const Text("Are you sure?", style: TextStyle()),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    "Yes",
                    style: TextStyle(),
                    ),
                    onPressed: (){
                      Navigator.of(context).pop();
                      setState((){
                        editForm = true;
                      });
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

  void _updateProductDialog() {
    showDialog(
      context: context, 
      builder: (BuildContext context){
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Update this products",
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
                    _updateProduct();
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
  
  void _updateProduct() {
    String _prname = _prnameEditingController.text;
    String _prdesc = _prdescEditingController.text;
    String _prprice = _prpriceEditingController.text;
    String _prqty = _prqtyEditingController.text;

    FocusScope.of(context).requestFocus(FocusNode());
    FocusScope.of(context).unfocus();
    ProgressDialog progressDialog = ProgressDialog(
      context,
      message: const Text("Updating products..."),
      title: const Text("Processing..."));
    progressDialog.show();

    if(_image == null){
      http.post(Uri.parse(CONSTANTS.server + "/fyp/php/update_product.php"),
        body: {
          "prid" : widget.product.prid,
          "prname": _prname,
          "prdesc": _prdesc,
          "prprice": _prprice,
          "prqty": _prqty,
        }).then((response){
          print(response.body);
          var data = jsonDecode(response.body);
          if(response.statusCode == 200 && data['status'] == 'success'){
            Fluttertoast.showToast(
              msg: "Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
              progressDialog.dismiss();
              Navigator.of(context).pop();
              return;
          }else{
            Fluttertoast.showToast(
              msg: "Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
              progressDialog.dismiss();
              return;
          }
        });
    } else{
      String base64Image = base64Encode(_image!.readAsBytesSync());
      http.post(Uri.parse(CONSTANTS.server + "/fyp/php/update_product.php"),
        body: {
          "prid" : widget.product.prid,
          "prname": _prname,
          "prdesc": _prdesc,
          "prprice": _prprice,
          "prqty:": _prqty,
          "image": base64Image,
        }).then((response){
          print(response.body);
          var data = jsonDecode(response.body);
          if(response.statusCode == 200 && data['status'] == 'success'){
            Fluttertoast.showToast(
              msg: "Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
              progressDialog.dismiss();
              Navigator.of(context).pop();
              return;
          }else{
            Fluttertoast.showToast(
              msg: "Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
              progressDialog.dismiss();
              return;
          }
        });
    }
    progressDialog.dismiss();
  }
}
