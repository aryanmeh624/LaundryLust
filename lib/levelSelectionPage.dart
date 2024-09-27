import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import image_picker for selecting images
import 'dart:io'; // For File class
import 'home.dart' as home;
import 'package:laundry_lust/cloth_data/main_DB.dart'; // Ensure you import your laundryData class
import 'cloth_data/change_clothes.dart'; // Import change_clothes for update functions

class LevelSelectionPage extends StatefulWidget {
  final laundryData laundryItem;
  final Function checkWashingCallback; // Add the callback

  LevelSelectionPage({required this.laundryItem, required this.checkWashingCallback}); // Pass the callback

  @override
  _LevelSelectionPageState createState() => _LevelSelectionPageState();
}

class _LevelSelectionPageState extends State<LevelSelectionPage> {
  Future<void> _updateDirtyLevel(int increment, BuildContext context) async {
    // Update the dirty value by the increment
    laundryData updatedLaundryItem = laundryData(
      id: widget.laundryItem.id,
      pic: widget.laundryItem.pic,
      lastWorn: DateTime.now().millisecondsSinceEpoch,
      dirty: widget.laundryItem.dirty + increment, // Update the dirty value
      name: widget.laundryItem.name,
    );
    await updatelaundry(updatedLaundryItem);
    // Call the callback
    // Pop the page to return to the previous screen
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Level'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Define percentage-based width for the buttons
          double buttonWidth = constraints.maxWidth * 0.25; // 25% of the screen width

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 114.0), // Reduced top padding to shift content slightly down
              child: Column(
                mainAxisSize: MainAxisSize.min,  // Ensures the column doesn't stretch unnecessarily
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: // Show the selected image
                    FileImage(File(widget.laundryItem.pic)), // Show the existing image
                    child: Align(
                      alignment: Alignment.topRight,
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),  // Adjusted padding for uniformity
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
                          SizedBox(
                            width: buttonWidth,
                            height: buttonWidth, // Maintain square shape
                            child: ElevatedButton(
                              onPressed: () {
                                _updateDirtyLevel(1, context);
                                widget.checkWashingCallback();
                              },
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(16), // Adjust padding if necessary
                              ),
                              child: Text(
                                '😊🌤️\nCool day\n(no sweat)',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('Level 1'),
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(
                            width: buttonWidth,
                            height: buttonWidth, // Maintain square shape
                            child: ElevatedButton(
                              onPressed: () {
                                _updateDirtyLevel(2, context);
                                widget.checkWashingCallback();
                              },
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(16), // Adjust padding if necessary
                              ),
                              child: Text(
                                '😅🌞\nHot but\nno workout',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('Level 2'),
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(
                            width: buttonWidth,
                            height: buttonWidth, // Maintain square shape
                            child: ElevatedButton(
                              onPressed: () {
                                _updateDirtyLevel(3, context);
                                widget.checkWashingCallback();
                              },
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(16), // Adjust padding if necessary
                              ),
                              child: Text(
                                '💪\nWorkout\n(fully wet)',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('Level 3'),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 24),  // Bottom padding to ensure space at the bottom
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
