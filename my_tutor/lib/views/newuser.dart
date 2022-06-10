import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../models/constant.dart';
import 'loginscreen.dart';

class NewUser extends StatefulWidget {
  const NewUser({Key? key}) : super(key: key);

  @override
  State<NewUser> createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
  late double screenHeight, screenWidth, ctrwidth;
  String pathAsset = 'assets/images/profile_picture.png';
  var _image;

  final TextEditingController _usernameEditingController = TextEditingController();
  final TextEditingController _userphoneEditingController = TextEditingController();
  final TextEditingController _useraddressEditingController = TextEditingController();
  final TextEditingController _useremailEditingController = TextEditingController();
  final TextEditingController _userpasswordEditingController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    print("dispose was called");
    _usernameEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 800) {
      ctrwidth = screenWidth / 1.5;
    }
    if (screenWidth < 800) {
      ctrwidth = screenWidth / 1.1;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('REGISTRATION'),
      ),
      body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
            child: Center(
                child: SizedBox(
        width: ctrwidth,
        child: Form(
            key: _formKey,
            child: Column(children: [
              const SizedBox(height: 10),
              Card(
                child: GestureDetector(
                    onTap: () => {_profilePictureDialog()},
                    child: SizedBox(
                        height: screenHeight / 2.5,
                        width: screenWidth,
                        child: _image == null
                            ? Image.asset(pathAsset)
                            : Image.file( 
                                _image,
                                fit: BoxFit.cover,
                              ))),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _usernameEditingController,
                decoration: InputDecoration(
                    labelText: 'Name',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter valid name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _userphoneEditingController,
                decoration: InputDecoration(
                    labelText: 'Phone No.',
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter valid phone no.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 5),
              TextFormField(
                controller: _useraddressEditingController,
                minLines: 6,
                keyboardType: TextInputType.multiline,
                maxLines: 6,
                decoration: InputDecoration(
                    labelText: 'Address',
                    alignLabelWithHint: true,
                    prefixIcon: const Padding(
                        padding: EdgeInsets.only(bottom: 100),
                        child: Icon(Icons.home)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter valid address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _useremailEditingController,
                decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _userpasswordEditingController,
                decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
                        validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter valid password';
                            }
                            if (value.length < 6) {
                              return "Password must be at least 6 characters";
                            }
                            return null;
                        },
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: screenWidth,
                height: 50,
                child: ElevatedButton(
                  child: const Text("Register",
                  style: TextStyle(fontSize: 17)),
                  onPressed: () {
                    _addDialog();
                  },
                ),
              ),
            ]),
        ),
      )),
          )),
    );
  }

  _profilePictureDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Text("Select From"),
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

  _galleryPicker() async {
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

  _cameraPicker() async {
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

  void _addDialog() {
    if (_formKey.currentState!.validate() && _image != null) {
      _formKey.currentState!.save();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Register as New User",
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
                  _addUser();
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
    else{
      Fluttertoast.showToast(
            msg: "Please insert your profile picture",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
    }
  }

  void _addUser() {
    FocusScope.of(context).requestFocus(FocusNode());
    String _username = _usernameEditingController.text;
    String _useraddress = _useraddressEditingController.text;
    String _userphone= _userphoneEditingController.text;
    String _useremail = _useremailEditingController.text;
    String _userpassword = _userpasswordEditingController.text;
    String base64Image = base64Encode(_image!.readAsBytesSync());
    
    http.post(
        Uri.parse(CONSTANT.server + "/my_tutor/mobile/php/new_user.php"),
        body: {
          "name": _username,
          "address": _useraddress,
          "phone": _userphone,
          "email": _useremail,
          "password": _userpassword,
          "image": base64Image,
        }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Register Successful",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
            Navigator.push(context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen()),
              );
      } else {
        Fluttertoast.showToast(
            msg: "Register Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
      }
    });
  }
}