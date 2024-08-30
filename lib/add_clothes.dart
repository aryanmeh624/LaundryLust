import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddClothes extends StatefulWidget {
  @override
  _AddClothesState createState() => _AddClothesState();
}

class _AddClothesState extends State<AddClothes> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  File? _image; // To store the image file

  // Function to open the camera and capture an image
  Future<void> _openCamera() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Clothes'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: _image == null
                      ? Text('No image selected.')
                      : SizedBox(
                    width: 150, // Set the desired width
                    height: 150, // Set the desired height
                    child: Image.file(
                      _image!,
                      fit: BoxFit.cover, // Ensure the image fits within the box
                    ),
                  ), // Display the image in a smaller size
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _openCamera, // Open the camera when button is pressed
                  child: Text('Take a Picture'),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Clothing Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Handle the submission, like saving the data to a database
                      print('Clothing Name: ${_nameController.text}');
                      if (_image != null) {
                        print('Image Path: ${_image!.path}');
                      }
                    }
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
