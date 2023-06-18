import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

void main() => runApp(FileUploadScreen());

class FileUploadScreen extends StatefulWidget {
  @override
  _FileUploadScreenState createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  late File _file;

  Future<void> _pickFile() async {
    final filePicker = ImagePicker();
    final pickedFile = await filePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _file = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadFile() async {
    if (_file == null) {
      return;
    }

    final url = Uri.parse('https://example.com/upload');
  
    final request = http.MultipartRequest('POST', url);
    final multipartFile = await http.MultipartFile.fromPath('file', _file.path);
  
    request.files.add(multipartFile);
  
    final response = await request.send();
  
    if (response.statusCode == 200) {
      print('File uploaded successfully!');
    } else {
      print('Error uploading file: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Upload'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _file != null ? Image.file(_file) : Container(),
          ElevatedButton(
            onPressed: _pickFile,
            child: Text('Select File'),
          ),
          ElevatedButton(
            onPressed: _uploadFile,
            child: Text('Upload File'),
          ),
        ],
      ),
    );
  }
}