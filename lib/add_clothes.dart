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
      backgroundColor: Colors.lightBlue[50], // Background color consistent with previous pages
       appBar: AppBar(
        title: Text(
          'Add Clothes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.indigo,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Display the image in a circular container
              Center(
                child: GestureDetector(
                  onTap: _openCamera,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.indigo.withOpacity(0.1),
                      image: _image != null
                          ? DecorationImage(
                        image: ResizeImage(FileImage(_image!),
                          width:100,
                          height: 100,
                          allowUpscaling: true,
                        ),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                    child: _image == null
                        ? Icon(
                      Icons.camera_alt,
                      color: Colors.indigo,
                      size: 50,
                    )
                        : null,
                  ),
                ),
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Clothing Name',
                  labelStyle: TextStyle(color: Colors.indigo),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.indigo),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.indigo),
                  ),
                ),
                cursorColor: Colors.indigo,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              Spacer(),
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
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.indigo, // Use backgroundColor instead of primary
                ),
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
