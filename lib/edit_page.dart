import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For picking images
import 'dart:io'; // For handling files
import 'package:laundry_lust/cloth_data/main_DB.dart'; // Import your laundryData class
import 'cloth_data/change_clothes.dart'; // Import change_clothes for update functions

class EditPage extends StatefulWidget {
  final laundryData laundryItem;

  EditPage({required this.laundryItem});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late TextEditingController _nameController;
  File? _image;

  @override
  void initState() {
    super.initState();
    // Initialize the controller with the current name of the laundry item
    _nameController = TextEditingController(text: widget.laundryItem.name);
  }

  // Function to allow the user to pick an image
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Function to update the laundry data in the database
  Future<void> _updateLaundryItem(BuildContext context) async {
    // If no image is selected, keep the original image
    String imagePath = _image != null ? _image!.path : widget.laundryItem.pic;

    // Create an updated laundryData object
    laundryData updatedLaundryItem = laundryData(
      id: widget.laundryItem.id,
      pic: imagePath,
      lastWorn: widget.laundryItem.lastWorn, // Keep the same "last worn" timestamp
      dirty: widget.laundryItem.dirty, // Keep the same dirty level for now
      name: _nameController.text, // Update the name with the input from the text controller
    );

    // Update the laundry item in the database
    await updatelaundry(updatedLaundryItem);

    // Pop the page to return to the previous screen and indicate the edit was successful
    Navigator.pop(context, true);
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
        title: Text('Edit Flashcard'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the current image, and allow the user to select a new one
            GestureDetector(
              onTap: _pickImage, // Allow the user to tap to change the image
              child: CircleAvatar(
                radius: 80,
                backgroundImage: _image != null
                    ? FileImage(_image!) // Show the selected image
                    : FileImage(File(widget.laundryItem.pic)), // Show the existing image
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(
                    Icons.edit,
                    color: Colors.blue,
                    size: 24,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Text field to update the name
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Edit Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Save button to update the laundry data
            ElevatedButton(
              onPressed: () {
                _updateLaundryItem(context); // Update the laundry item when the button is pressed
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
