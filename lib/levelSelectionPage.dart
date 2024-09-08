import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import image_picker for selecting images
import 'dart:io'; // For File class
import 'package:laundry_lust/cloth_data/main_DB.dart'; // Ensure you import your laundryData class
import 'cloth_data/change_clothes.dart'; // Import change_clothes for update functions

class LevelSelectionPage extends StatefulWidget {
  final laundryData laundryItem;

  LevelSelectionPage({required this.laundryItem});

  @override
  _LevelSelectionPageState createState() => _LevelSelectionPageState();
}

class _LevelSelectionPageState extends State<LevelSelectionPage> {
  File? _image;

  Future<void> _updateDirtyLevel(int increment, BuildContext context) async {
    // Increase the dirty value by the increment
    laundryData updatedLaundryItem = laundryData(
      id: widget.laundryItem.id,
      pic: widget.laundryItem.pic,
      lastWorn: DateTime.now().millisecondsSinceEpoch,
      dirty: widget.laundryItem.dirty + increment, // Update the dirty value
      name: widget.laundryItem.name,
    );
    // Call the update function to update the database
    await updatelaundry(updatedLaundryItem);

    // Pop the page to return to the previous screen
    Navigator.pop(context,true);
  }
  //
  // Future<void> _pickImage() async {
  //   final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     setState(() {
  //       _image = File(pickedFile.path);
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Level'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context,true);
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'How was your use of the cloth today?',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () => _updateDirtyLevel(1, context),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(24),
                    ),
                    child: Text(
                      '😊🌤️\nCool day\n(no sweat)',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('Level 1'),
                ],
              ),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () => _updateDirtyLevel(2, context),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(24),
                    ),
                    child: Text(
                      '😅🌞\nHot but\nno workout',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('Level 2'),
                ],
              ),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () => _updateDirtyLevel(3, context),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(24),
                    ),
                    child: Text(
                      '💪\nWorkout\n(fully wet)',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('Level 3'),
                ],
              ),
            ],
          ),

        ],
      ),
    );
  }
}
